import json

with open("incident.json", "r") as file:
    data = json.load(file)

print(f"Incident ID: {data['id']}")
print(f"Description: {data['description']}")
print(f"Statut: {data['statut']}")
