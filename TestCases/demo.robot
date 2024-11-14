*** Settings ***
Resource    ../Keywords/keyword.resource

    
*** Test Cases ***
Open and Login to SauceDemo
    Open a browser and navigate to Sauce Demo
    Log in with test credentials
    Add a few products to the cart
    Go to the Cart and validate that all selected items are present
    Continue to checkout and validate the items and totals at each step
    
    
    