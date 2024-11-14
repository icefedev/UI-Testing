*** Settings ***
Library     SeleniumLibrary
Library     String
Resource    ../XPATH/xpath.resource
Resource    ../Variables/variable.resource

*** Keywords ***
Open a browser and navigate to Sauce Demo
    Open Browser    ${url_test_login}    chrome    options=add_argument("--start-maximized")

Log in with test credentials
    Input Text      xpath:${text_username}    ${username}
    Input Text      xpath:${text_password}    ${password}
    Click Button    xpath:${text_login}


Add a few products to the cart
    ${itemname_backpack}     Get Text    xpath:${text_backpack} 
    ${itemname_bikelight}    Get Text    xpath:${text_bikelight} 
    ${itemname_tshirt}       Get Text    xpath:${text_thsirt} 

    Set Global Variable    ${itemname_backpack}
    Set Global Variable    ${itemname_bikelight}
    Set Global Variable    ${itemname_tshirt}

    Click Button    xpath:${button_backpack}
    Click Button    xpath:${button_bikelights}
    Click Button    xpath:${button_tshirt}



Go to the Cart and validate that all selected items are present
    
    Click Link      xpath:${button_cart}

    ${itemname_backpack2}     Get Text    xpath:${text_backpack2} 
    ${itemname_bikelight2}    Get Text    xpath:${text_bikelight2} 
    ${itemname_tshirt2}       Get Text    xpath:${text_thsirt2} 

    Should Be Equal    ${itemname_backpack}     ${itemname_backpack2} 
    Should Be Equal    ${itemname_bikelight}    ${itemname_bikelight2} 
    Should Be Equal    ${itemname_tshirt}       ${itemname_tshirt2} 
    

Continue to checkout and validate the items and totals at each step
    Click checkout and Fill The Information
    Validate Product and Item Total
    Calculate Tax 
    Check totals


Click checkout and Fill The Information
    Click Button    xpath:${button_checkout}
    Input Text      xpath:${text_fname}      ${fname} 
    Input Text      xpath:${text_sname}      ${sname}
    Input Text      xpath:${text_zipcode}    ${zipcode}
    Click Button    xpath:${button_submit}

Validate Product and Item Total
    ${itemname_backpack3}     Get Text    xpath:${text_backpack3} 
    ${itemname_bikelight3}    Get Text    xpath:${text_bikelight3} 
    ${itemname_tshirt3}       Get Text    xpath:${text_thsirt3} 

    Should Be Equal    ${itemname_backpack3}     ${itemname_backpack} 
    Should Be Equal    ${itemname_bikelight3}    ${itemname_bikelight} 
    Should Be Equal    ${itemname_tshirt3}       ${itemname_tshirt} 

    ${price_backpack}     Get Text    xpath:${text_pricebackpack}
    ${price_bikelight}    Get Text    xpath:${text_pricebikelight}
    ${price_tshirt}       Get Text    xpath:${text_pricetshirt}

    ${price_backpack}     Remove String    ${price_backpack}     $
    ${price_bikelight}    Remove String    ${price_bikelight}    $
    ${price_tshirt}       Remove String    ${price_tshirt}       $       
    
    ${price_backpack}     Evaluate    float(${price_backpack})
    ${price_bikelight}    Evaluate    float(${price_bikelight})
    ${price_tshirt}       Evaluate    float(${price_tshirt})

    ${result}    Evaluate    ${price_backpack} + ${price_bikelight} + ${price_tshirt} 
    Log          Item Total = ${result}
    Set Global Variable       ${result}

Calculate Tax 
    ${checktax}    Get Text         xpath:${text_tax}
    ${checktax}    Remove String    ${checktax}    Tax: $
    ${checktax}    Evaluate         float(${checktax})  
    
    ${tax}    Evaluate   round(${result} * 8 / 100, 2)
    Log       tax = ${tax} 

    Should Be Equal    ${checktax}    ${tax}
    Set Global Variable    ${tax}

    
Check totals
    ${totals}          Get Text         xpath:${text_total}
    ${totals}          Remove String    ${totals}     Total: $
    ${totals}          Evaluate         float(${totals})
    
    ${Item_total}      Evaluate         ${result} + ${tax}
    Log                Total = ${Item_total}

    Should Be Equal    ${totals}        ${Item_total}
    Click Button       xpath:${button_finish}


