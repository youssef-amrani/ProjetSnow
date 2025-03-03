*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${JIRA_URL}      https://riadamine59.atlassian.net
${JIRA_USER}     riadamine59@gmail.com
${JIRA_TOKEN}    ATATT3xFfGF0iz_oNz899-uSJQYn8zxAQCPPN8di_sX5sbgqRe5ZWk6LML4HEvo0Vvsz5FS8_MCAjEVeWC9o-QdQ4eo3Cnsv-EAmpzHmanumHtLxoxWF4QkPQ5xVjPN6Yvkdf0RZdd0nTo9qMCfjCnkg7Fk-sBFKFArusJIdxpQXJiGYlH5DMME=AB3A04D4

*** Test Cases ***
Créer un ticket Jira pour un incident récupéré
    [Documentation]    Tester la création d'un ticket Jira avec les mêmes données que Postman
    
    # 🔹 Création correcte du JSON
    ${project}=    Create Dictionary    key=AL
    ${issuetype}=    Create Dictionary    name=Tâche
    ${fields}=    Create Dictionary
    ...    project=${project}
    ...    summary=Incident de test depuis Robot Framework
    ...    description=Test manuel avant automatisation
    ...    issuetype=${issuetype}

    ${data}=    Create Dictionary    fields=${fields}

    # 🔹 Ajouter les headers pour l'authentification
    ${headers}=    Create Dictionary
    ...    Authorization=Basic ${JIRA_USER}:${JIRA_TOKEN}
    ...    Content-Type=application/json

    # 🔹 Créer la session et envoyer la requête
   ${auth}=    Create List    ${JIRA_USER}    ${JIRA_TOKEN}
    Create Session    jira    ${JIRA_URL}    auth=${auth}

    ${response}=    POST On Session    jira    /rest/api/2/issue    json=${data}
    Log    ${response.content}    # Ajoute cette ligne


    # 🔹 Vérification du succès
    Should Be Equal As Numbers    ${response.status_code}    201
    Log    "✅ Ticket Jira créé avec succès"
