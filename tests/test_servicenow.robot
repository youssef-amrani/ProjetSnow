*** Settings ***
Resource    ../resources/servicenow_keywords.robot
Library    ../libraries/shadow.py
Suite Setup    Ouvrir le navigateur ServiceNow
#Suite Teardown    Fermer le navigateur

*** Test Cases ***
Création et vérifications d’un ticket sur ServiceNow
    [Documentation]    Simule la création d’un ticket LTT ServiceNow et vérifie l’ensemble des éléments requis.
    Se connecter à ServiceNow
    Sleep    time_=20
    #Remplir champ global search    créer IU
    Cliquer Sur Bouton All
    Sleep    time_=20
    Rechercher Et Selectionner Creer Iu
    Sleep    time_=20
    Remplir Champs Obligatoires Creer IU
    Sleep    time_=20