*** Settings ***
Library    RequestsLibrary
Library    JiraUpload.py
Library    Collections
Library    JSONLibrary
Library    OperatingSystem
Library    Process

*** Variables ***
${JIRA_URL}      https://riadamine59.atlassian.net
${JIRA_USER}     riadamine59@gmail.com
${JIRA_TOKEN}    ATATT3xFfGF0aAZapsM-L_APMxFiUDL8l_OWdCjwlVs_urzUiVtmHpzI1wDtZJ7nVXc5VQpbc1tTeQ1HV4lKRPeZiEes-bXo_itdTThE1EiYYa-xIRnCXYC29Pj3z3ihD7O3Ca0nwOlhdN6HP5ktV5gZOsrOpfp2rprfJ1y1NhsOl3H9jFosASs=4DB2AA5C
${ATTACHMENT_PATH}    C:/Users/geams/OneDrive/Bureau/Jira.txt 

*** Test Cases ***
Créer un ticket Jira et effectuer des actions post-création
    [Documentation]    Créer un ticket et ajouter un commentaire, mettre à jour le statut, et ajouter une pièce jointe.

    # 🔹 Création du ticket
    ${ticket_key}=    Créer un ticket Jira

    Log    "🔹 Ticket clé récupérée par Robot Framework : ${ticket_key}"
    
    # Lister et afficher les transitions disponibles
    ${transitions}=    Lister les transitions disponibles    ${ticket_key}

    Ajouter un commentaire    ${ticket_key}    "Ce ticket a été créé automatiquement via Robot Framework et a été commenté."
    Mettre à jour le statut du ticket    ${ticket_key}    Done
    
    # 🔹 Ajout de la pièce jointe
    Ajouter une pièce jointe    ${ticket_key}    ${ATTACHMENT_PATH}

*** Keywords ***
*** Keywords ***
Créer un ticket Jira
    [Documentation]    Création d'un ticket Jira et retour de sa clé (ex: AL-79).
    
    ${project}=    Create Dictionary    key=AL
    ${issuetype}=    Create Dictionary    name=Tâche
    ${fields}=    Create Dictionary
    ...    project=${project}
    ...    summary=Incident de test depuis Robot Framework
    ...    description=Ticket généré automatiquement pour test d'automatisation
    ...    issuetype=${issuetype}

    ${data}=    Create Dictionary    fields=${fields}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${auth}=    Create List    ${JIRA_USER}    ${JIRA_TOKEN}
    Create Session    jira    ${JIRA_URL}    auth=${auth}    headers=${headers}    verify=False

    ${response}=    POST On Session    jira    /rest/api/2/issue    json=${data}
    Should Be Equal As Numbers    ${response.status_code}    201

    # 🔑 Récupération directe de la clé du ticket sans passer par une liste
    ${ticket_key}=    Set Variable    ${response.json()["key"]}
    Log    "✅ Ticket créé avec la clé : ${ticket_key}"

    RETURN   ${ticket_key}


Lister les transitions disponibles
    [Arguments]    ${ticket_key}
    [Documentation]    Affiche toutes les transitions disponibles pour un ticket
    
    ${available_transitions}=    GET On Session    jira    /rest/api/2/issue/${ticket_key}/transitions
    Log    "Transitions disponibles pour le ticket ${ticket_key}:"
    
    FOR    ${transition}    IN    @{available_transitions.json()["transitions"]}
        Log    "ID: ${transition["id"]}, Nom: ${transition["name"]}"
    END
    
    RETURN    ${available_transitions.json()["transitions"]}
    

Ajouter un commentaire
    [Arguments]    ${ticket_key}    ${commentaire}
    [Documentation]    Ajoute un commentaire à un ticket Jira.

    ${data}=    Create Dictionary    body=${commentaire}
    ${response}=    POST On Session    jira    /rest/api/2/issue/${ticket_key}/comment    json=${data}

    Should Be Equal As Numbers    ${response.status_code}    201
    Log    "✅ Commentaire ajouté au ticket ${ticket_key}"

Mettre à jour le statut du ticket
    [Arguments]    ${ticket_key}    ${transition_name}
    [Documentation]    Change le statut du ticket Jira via son nom.

    # 🔹 Récupération des transitions possibles
    ${transitions}=    Lister les transitions disponibles    ${ticket_key}

    # 🔹 Trouver l'ID correspondant au nom donné
    ${transition_id}=    Set Variable    None
    FOR    ${transition}    IN    @{transitions}
        IF    '${transition["name"]}' == '${transition_name}'
            ${transition_id}=    Set Variable    ${transition["id"]}
            BREAK
        END
    END

    Run Keyword If    '${transition_id}' == 'None'    Fail    "❌ Transition '${transition_name}' non trouvée."

    # 🔹 Exécution de la transition
    ${transition_data}=    Create Dictionary    id=${transition_id}
    ${data}=    Create Dictionary    transition=${transition_data}

    ${response}=    POST On Session    jira    /rest/api/2/issue/${ticket_key}/transitions    json=${data}

    Log    "🔹 Réponse HTTP: ${response.status_code}"
    Log    "🔹 Contenu de la réponse: ${response.content}"

    Should Be Equal As Numbers    ${response.status_code}    204
    Log    "✅ Ticket ${ticket_key} mis à jour avec la transition '${transition_name}'"

Ajouter une pièce jointe
    [Arguments]    ${ticket_key}    ${file_path}
    [Documentation]    Ajoute une pièce jointe au ticket Jira via la librairie Python personnalisée.

    Log    "🔹 Ajout de la pièce jointe '${file_path}' au ticket '${ticket_key}'"

    # 🔐 Appel de la méthode Python "upload_file" depuis JiraUpload
    ${result}=    Upload File    ${ticket_key}    ${file_path}    ${JIRA_USER}    ${JIRA_TOKEN}

    Log    "✅ Résultat de l'ajout de pièce jointe : ${result}"