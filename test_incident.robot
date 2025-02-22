*** Settings ***
Library    JSONLibrary

*** Test Cases ***
Vérifier Incident
    [Documentation]    Vérifie que l'incident contient bien une description et un statut.
    ${incident}    Load JSON From File    incident.json
    Should Not Be Empty    ${incident["description"]}
    Should Be Equal    ${incident["statut"]}    Ouvert
