from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

# Télécharge et utilise automatiquement la bonne version de ChromeDriver
service = Service(ChromeDriverManager().install())

# Lance Chrome
driver = webdriver.Chrome(service=service)

# Ouvre Google
driver.get("https://www.google.com")
print("Titre de la page :", driver.title)

# Ferme le navigateur
driver.quit()
