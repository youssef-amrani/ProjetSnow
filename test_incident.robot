*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${JIRA_URL}      https://riadamine59.atlassian.net/rest/api/2
${JIRA_USER}     ton.email@exemple.com
${JIRA_TOKEN}    TON_API_TOKEN

*** Test Cases ***
Créer un ticket Jira pour un incident récupéré
    [Documentation]    Récupérer un incident fictif et créer un ticket Jira

    # 🔹 Simulation d'un incident de ServiceNow
    ${incident}=    Create Dictionary
    ...    id=12345
    ...    description=Connexion impossible
    ...    assigne_a=Tech Support

    # 🔹 Construction correcte du JSON pour Jira
    ${project}=    Create Dictionary    key=AL
    ${issuetype}=    Create Dictionary    name=Bug

    ${summary}    Catenate    Incident ${incident}[id] - ${incident}[description]
    ${description}    Catenate    Assigné à ${incident}[assigne_a]

    ${fields}=    Create Dictionary
    ...    project=${project}
    ...    summary=${summary}
    ...    description=${description}
    ...    issuetype=${issuetype}

    ${data}=    Create Dictionary    fields=${fields}

    # 🔹 Création de session avec authentification correcte
    ${headers}=    Create Dictionary    Authorization=Basic ${JIRA_USER}:${JIRA_TOKEN}    Content-Type=application/json
    Create Session    jira    ${JIRA_URL}    headers=${headers}

    # 🔹 Envoi de la requête pour créer le ticket
    ${response}=    Post Request    jira    /issue    json=${data}

    # 🔹 Vérification du succès
    Should Be Equal As Numbers    ${response.status_code}    201
    Log    ✅ Ticket créé avec succès
