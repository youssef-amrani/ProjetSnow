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

    # 🔹 Ajouter les headers
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json

    # 🔹 Créer la session avec authentification correcte
    ${auth}=    Create List    ${JIRA_USER}    ${JIRA_TOKEN}
    Create Session    jira    ${JIRA_URL}    auth=${auth}    headers=${headers}

    # 🔹 Envoyer la requête POST
    ${response}=    POST On Session    jira    /rest/api/2/issue    json=${data}

    # 🔹 Log de la réponse
    Log    ${response.status_code}
    Log    ${response.content}

    # 🔹 Vérification du succès
    Should Be Equal As Numbers    ${response.status_code}    201
    Log    "✅ Ticket Jira créé avec succès"

    # 🔹 Extraction de l'ID du ticket
    ${ticket_id}=    Get Value From Json    ${response.json()}    $.id
    ${ticket_id}=    Set Variable    ${ticket_id}[0]    # Extraire la valeur de la liste
    Log    "🔹 ID du ticket Jira: ${ticket_id}"

    # 🔹 Vérification du ticket via GET
    ${ticket_response}=    GET On Session    jira    /rest/api/2/issue/${ticket_id}
    Should Be Equal As Numbers    ${ticket_response.status_code}    200
    Log    "✅ Ticket Jira récupéré avec succès"
