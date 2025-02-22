*** Settings ***
Library    SeleniumLibrary

*** Test Cases ***
Créer Ticket JIRA
    Open Browser    https://faux-jira.com/create-ticket    chrome
    Input Text    id=summary    Incident détecté - Données manquantes
    Input Text    id=description    Problème détecté avec enrichissement client
    Click Button    id=submit
    Close Browser
