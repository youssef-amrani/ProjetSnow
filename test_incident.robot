*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${JIRA_URL}      https://riadamine59.atlassian.net/rest/api/2/issue
${JIRA_USER}     ton.email@exemple.com
${JIRA_TOKEN}    TON_API_TOKEN

*** Test Cases ***
Créer un ticket Jira pour un incident récupéré
    [Documentation]    Récupérer un incident fictif et créer un ticket Jira
    
    # 🔹 Simulation d'un incident de ServiceNow
    ${incident}=    Create Dictionary
    ...    id=12345
    ...    description=Connexion impossible
    ...    assigné_à=Tech Support

    # 🔹 Création du ticket Jira
    ${data}=    Create Dictionary
    ...    fields=${{"project": {"key": "AL"},
    ...              "summary": "Incident ${incident}[id] - ${incident}[description]",
    ...              "description": "Assigné à ${incident}[assigné_à]",
    ...              "issuetype": {"name": "Bug"}}}

    Create Session    jira    ${JIRA_URL}    auth=(${JIRA_USER}, ${JIRA_TOKEN})
    ${response}=    Post Request    jira    /issue    json=${data}
    
    # 🔹 Vérification du succès
    Should Be Equal As Numbers    ${response.status_code}    201
    Log    "✅ Ticket créé avec succès"
