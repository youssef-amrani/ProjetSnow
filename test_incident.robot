*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    OperatingSystem
Library    Process

*** Variables ***
${JIRA_URL}      https://riadamine59.atlassian.net
${JIRA_USER}     riadamine59@gmail.com
${JIRA_TOKEN}    -L_APMxFiUDL8l_OWdCjwlVs_urzUiVtmHpzI1wDtZJ7nVXc5VQpbc1tTeQ1HV4lKRPeZiEes-bXo_itdTThE1EiYYa-xIRnCXYC29Pj3z3ihD7O3Ca0nwOlhdN6HP5ktV5gZOsrOpfp2rprfJ1y1NhsOl3H9jFosASs=4DB2AA5C
${ATTACHMENT_PATH}    C:/Users/geams/OneDrive/Bureau/English.txt 

*** Test Cases ***
Créer un ticket Jira et effectuer des actions post-création
    [Documentation]    Créer un ticket et ajouter un commentaire, mettre à jour le statut, et ajouter une pièce jointe.

    # 🔹 Création du ticket
    ${ticket_id}=    Créer un ticket Jira
    
    # Lister et afficher les transitions disponibles
    ${transitions}=    Lister les transitions disponibles    ${ticket_id}

    Ajouter un commentaire    ${ticket_id}    "Ce ticket a été créé automatiquement via Robot Framework et a été commenté."
    Mettre à jour le statut du ticket    ${ticket_id}    211 

*** Keywords ***
Créer un ticket Jira
    [Documentation]    Création d'un ticket Jira et retour de son ID.
    
    ${project}=    Create Dictionary    key=AL
    ${issuetype}=    Create Dictionary    name=Tâche
    ${fields}=    Create Dictionary
    ...    project=${project}
    ...    summary=Incident de test depuis Robot Framework
    ...    description=Test manuel avant automatisation
    ...    issuetype=${issuetype}

    ${data}=    Create Dictionary    fields=${fields}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${auth}=    Create List    ${JIRA_USER}    ${JIRA_TOKEN}
    Create Session    jira    ${JIRA_URL}    auth=${auth}    headers=${headers}    verify=False

    ${response}=    POST On Session    jira    /rest/api/2/issue    json=${data}
    Should Be Equal As Numbers    ${response.status_code}    201

    ${ticket_id}=    Get Value From Json    ${response.json()}    $.id

    ${ticket_id}=    Set Variable    ${ticket_id}[0]    # Extraire la valeur de la liste
    Log    "🔹 ID du ticket Jira: ${ticket_id}"


    Log    "✅ Ticket créé : ${ticket_id}"
    RETURN    ${ticket_id}

Lister les transitions disponibles
    [Arguments]    ${ticket_id}
    [Documentation]    Affiche toutes les transitions disponibles pour un ticket
    
    ${available_transitions}=    GET On Session    jira    /rest/api/2/issue/${ticket_id}/transitions
    Log    "Transitions disponibles pour le ticket ${ticket_id}:"
    
    FOR    ${transition}    IN    @{available_transitions.json()["transitions"]}
        Log    "ID: ${transition["id"]}, Nom: ${transition["name"]}"
    END
    
    [Return]    ${available_transitions.json()["transitions"]}
    

Ajouter un commentaire
    [Arguments]    ${ticket_id}    ${commentaire}
    [Documentation]    Ajoute un commentaire à un ticket Jira.

    ${data}=    Create Dictionary    body=${commentaire}
    ${response}=    POST On Session    jira    /rest/api/2/issue/${ticket_id}/comment    json=${data}

    Should Be Equal As Numbers    ${response.status_code}    201
    Log    "✅ Commentaire ajouté au ticket ${ticket_id}"

Mettre à jour le statut du ticket
    [Arguments]    ${ticket_id}    ${transition_id}
    [Documentation]    Change le statut du ticket Jira via une transition.

    ${transition_id}=    Convert To String    ${transition_id}  # 🔹 Convertir en chaîne si besoin

    Log    "🔹 Tentative de mise à jour du ticket ${ticket_id} avec la transition ID ${transition_id}"

    ${transition}=    Create Dictionary    id=${transition_id}
    ${data}=    Create Dictionary    transition=${transition}

    ${response}=    POST On Session    jira    /rest/api/2/issue/${ticket_id}/transitions    json=${data}

    Log    "🔹 Réponse HTTP: ${response.status_code}"
    Log    "🔹 Contenu de la réponse: ${response.content}"  # 🔹 Affiche l'erreur retournée

    Should Be Equal As Numbers    ${response.status_code}    204
    Log    "✅ Ticket ${ticket_id} mis à jour avec la transition ID ${transition_id}"
