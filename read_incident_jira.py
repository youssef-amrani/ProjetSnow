import json
import requests

# URL ServiceNow API (Exemple, adapter avec ton instance)
SERVICENOW_URL = "https://votre-instance.service-now.com/api/now/table/incident"
SERVICENOW_USER = "ton_utilisateur"
SERVICENOW_PASSWORD = "ton_mot_de_passe"

# Headers
headers = {
    "Accept": "application/json",
    "Content-Type": "application/json"
}

# Authentification
auth = (SERVICENOW_USER, SERVICENOW_PASSWORD)

# Récupération des incidents ServiceNow
print("📡 Récupération des incidents depuis ServiceNow...")
response = requests.get(SERVICENOW_URL, headers=headers, auth=auth)

if response.status_code == 200:
    incidents = response.json().get("result", [])
    print(f"✅ {len(incidents)} incidents récupérés.")
    
    # Sauvegarde en JSON
    with open("incident.json", "w", encoding="utf-8") as f:
        json.dump(incidents, f, indent=4, ensure_ascii=False)
    
    print("💾 Données enregistrées dans incident.json")
else:
    print(f"❌ Erreur lors de la récupération des incidents : {response.text}")
