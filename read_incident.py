import json

# Charger le fichier incident.json
with open("incident.json", "r", encoding="utf-8") as file:
    incident = json.load(file)

# Vérifier si l'incident est "Ouvert"
if incident["statut"] == "Ouvert":
    print(f"📢 Un incident nécessite une action : {incident['id']}")
    print(f"📝 Description : {incident['description']}")
    print(f"👨‍💻 Assigné à : {incident['assigné_à']}")
    print("🚀 Simulation : Création d'un ticket Jira...")

    # Ici, on pourrait envoyer une requête API à Jira pour créer un ticket (quand on aura accès)
else:
    print(f"✅ Incident {incident['id']} déjà traité ({incident['statut']})")
