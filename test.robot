*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${BROWSER}  chrome
${URL}  https://www.bing.com
${SEARCH_INPUT}  name=q
${SEARCH_BUTTON}  xpath=//input[@type='submit']

*** Test Cases ***
Rechercher un mot clé sur Bing
    Open Browser  ${URL}  ${BROWSER}
    Maximize Browser Window
    Input Text  ${SEARCH_INPUT}  Robot Framework
    Sleep  1s
    Press Keys  ${SEARCH_INPUT}  ENTER
    Wait Until Page Contains  Robot Framework
    Close Browser
