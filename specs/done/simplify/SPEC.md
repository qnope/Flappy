# Simplify — Feature Specification

## 1. Feature Overview

Ce projet poursuit la simplification du jeu Flappy en deux axes :

1. **Suppression de la position X du Bird** : Le bird est toujours centré horizontalement via `Alignment(0, ...)`. La propriété `posX` dans le modèle `Bird`, le paramètre `birdX` dans `GameController.initialize()`, et le calcul associé dans `GameScreen` sont inutiles et doivent être supprimés.

2. **Utilisation de ListenableBuilder** : `GameController` étend déjà `ChangeNotifier` et appelle `notifyListeners()` à chaque frame, mais `GameScreen` n'exploite pas ce mécanisme — il appelle manuellement `setState(() {})` après `_controller.update(dt)`. Le rebuild doit être déclenché automatiquement par un `ListenableBuilder` qui écoute le controller.

## 2. User Stories

### US1 — Suppression de posX du Bird

**En tant que** développeur,
**je veux** que le modèle Bird ne contienne plus de propriété `posX`,
**afin que** le code reflète la réalité : le bird ne se déplace jamais horizontalement.

**Critères d'acceptation :**
- La propriété `posX` est supprimée du modèle `Bird`
- Le paramètre `birdX` est supprimé de `GameController.initialize()`
- Le calcul de `birdX` dans `GameScreen` est supprimé
- Le bird reste visuellement centré horizontalement (comportement inchangé)
- Tous les tests existants passent (mis à jour si nécessaire pour retirer les références à posX)

### US2 — ListenableBuilder pour le rendu

**En tant que** développeur,
**je veux** que `GameScreen` utilise un `ListenableBuilder` écoutant le `GameController`,
**afin que** le rebuild du widget soit déclenché automatiquement par `notifyListeners()` sans appel manuel à `setState`.

**Critères d'acceptation :**
- `GameScreen` reste un `StatefulWidget` (pour gérer le `Ticker` et le lifecycle)
- L'appel `setState(() {})` après `_controller.update(dt)` est supprimé
- Un `ListenableBuilder` wrappant les widgets du jeu écoute le `GameController`
- Le Ticker appelle `_controller.update(dt)` sans déclencher de rebuild directement
- Le comportement visuel du jeu est identique (bird, animation des ailes, rotation, bobbing)
- Tous les tests existants passent

## 3. Testing and Validation

- **Tests unitaires** : Mettre à jour les tests de `Bird` pour retirer les références à `posX`. Mettre à jour les tests de `GameController` pour retirer le paramètre `birdX`.
- **Tests widget** : Vérifier que `GameScreen` fonctionne correctement avec `ListenableBuilder`. Le bird doit toujours être positionné correctement et les animations doivent fonctionner.
- **Tests d'intégration** : Le flow complet du jeu (idle → tap → playing → ground collision) doit fonctionner identiquement.
- **Critère de succès** : Tous les tests passent, le comportement visuel est identique, le code est plus simple et idiomatique Flutter.
