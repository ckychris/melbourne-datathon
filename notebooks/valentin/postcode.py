"""
Just a small function that will fetch the longitude and latitude values of a given postcode
"""

import urllib
import json


def get_latlon(mypostcode = 3182):
    """
    Obtaining some longitude and latitude values for the provided postcodes.
    
    Parameter:
    ==========
        mypostcode: int (or str)
            The postcode.
            
    Return:
    =======
        lat: float
            Latitude
        lon: float
            Longitude
    """
    
    url = "http://v0.postcodeapi.com.au/suburbs/{postal_code}.json".format(postal_code = mypostcode)
    # We need this header (specifically the User-Agent field), otherwise it will returns a HTTP 403 error.
    hdr = {'Accept': 'application/json',
           'User-Agent': 'Mozilla/5.0'}
    
    # Opening a request
    request = urllib.request.Request(url, headers = hdr)
    # Opening url
    with urllib.request.urlopen(request) as webpage:
        # Loading JSON data
        data = json.loads(webpage.read().decode())
        
    data_sl = data[0]
    lat = data_sl['latitude']
    lon = data_sl['longitude']
    # locality = data_sl['name']
    # state = data_sl['state']['abbreviation']
    
    return lat, lon