# Database Model for a Team Collaboration App

A project simulating the process of managing team collaboration, based on the operational model of an application like Microsoft Teams. The main focus is on correct relational modeling, maintaining data integrity, and implementing business rules at the database layer.

## Project Goal
The system is designed to handle the processes of assigning user roles, creating events, and evaluating tasks within teams. The project demonstrates the practical application of the following database concepts:
* **Relational Design:** Table normalization, the use of primary and foreign keys to build relationships and maintain the consistency of dictionary data (roles, regions, privacy settings).
* **Business Logic Validation:** Utilizing triggers to block unauthorized operations, such as assigning administrative privileges to incorrect email domains, resuming completed tasks, or exceeding membership limits.
* **Process Automation:** Using stored procedures to manage user roles by analyzing and aggregating their assigned ratings.

## Technologies Used
* **Languages:** T-SQL, PL/SQL
* **Platforms:** SQL Server, Oracle Database
* **Key Mechanisms:** Triggers (protecting related records from deletion, logic condition validation), Stored Procedures (encapsulating the logic of analyzing results and updating permissions), Sequences (solving concurrency issues when generating primary keys).

---
PL

# Model Bazy Danych dla Aplikacji Zespołowej

Projekt symulujący proces zarządzania współpracą w zespołach, oparty na modelu działania aplikacji typu Microsoft Teams. Główny nacisk postawiono na poprawne modelowanie relacyjne, utrzymanie integralności danych oraz wdrożenie reguł biznesowych na poziomie warstwy danych.

## Cel projektu
System ma za zadanie obsłużyć procesy przypisywania ról użytkownikom, tworzenia wydarzeń oraz ewaluacji zadań wewnątrz zespołów. Projekt demonstruje praktyczne zastosowanie następujących koncepcji bazodanowych:
* **Projektowanie Relacyjne:** Normalizacja tabel, wykorzystanie kluczy głównych oraz obcych w celu budowy relacji i utrzymania spójności danych słownikowych (role, regiony, prywatność).
* **Walidacja logiki biznesowej:** Wykorzystanie wyzwalaczy (triggerów) do blokowania niedozwolonych operacji, takich jak przypisywanie uprawnień administracyjnych dla nieodpowiednich domen pocztowych, wznawianie zakończonych zadań czy przekraczanie limitów członkostwa.
* **Automatyzacja procesów:** Wykorzystanie procedur składowanych do zarządzania rolami użytkowników poprzez analizę i agregację wystawionych im ocen. 

## Wykorzystane technologie
* **Języki:** T-SQL, PL/SQL
* **Platformy:** SQL Server, Oracle Database
* **Kluczowe mechanizmy:** Wyzwalacze (ochrona rekordów powiązanych przed usunięciem, walidacja warunków logicznych), Procedury składowane (hermetyzacja logiki analizy wyników i aktualizacji uprawnień), Sekwencje (rozwiązanie problemów współbieżności przy tworzeniu kluczy głównych).
