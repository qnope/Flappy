# Collide, Game Over & Scoring — Feature Specification

## 1. Feature Overview

Ajouter les trois mécaniques fondamentales manquantes au jeu Flappy Bird :
- **Collision** : Détection des collisions entre l'oiseau et les tuyaux ou le sol.
- **Game Over** : Un état de fin de partie avec animation de chute et écran dédié.
- **Scoring** : Un compteur de score qui s'incrémente à chaque tuyau passé.

## 2. User Stories

### US1 — Collision avec les tuyaux
**En tant que** joueur,
**je veux** que l'oiseau meure quand il touche un tuyau,
**afin que** le jeu présente un véritable défi.

**Critères d'acceptation :**
- L'oiseau entre en collision avec la partie haute ou basse d'un tuyau (corps + casquette).
- La collision déclenche l'état "dying" : l'oiseau ne répond plus aux taps.
- Les tuyaux, le sol et les nuages cessent de défiler immédiatement.
- L'oiseau tombe au sol avec la gravité (animation de chute).
- L'écran de game over s'affiche une fois que l'oiseau atteint le sol.

### US2 — Collision avec le sol
**En tant que** joueur,
**je veux** que toucher le sol mette fin à la partie,
**afin que** le jeu soit cohérent avec la mécanique de survie.

**Critères d'acceptation :**
- Si l'oiseau touche le sol en état "playing", il passe directement en game over (pas besoin de chute supplémentaire, il est déjà au sol).
- Si l'oiseau touche le sol en état "dying" (après collision tuyau), l'écran de game over s'affiche.

### US3 — Score en jeu
**En tant que** joueur,
**je veux** voir mon score augmenter à chaque tuyau que je passe,
**afin de** mesurer ma progression.

**Critères d'acceptation :**
- Le score démarre à 0 au début de la partie.
- Le score s'incrémente de 1 quand le centre de l'oiseau dépasse le bord droit d'un tuyau.
- Chaque tuyau ne peut compter qu'une seule fois.
- Le score est affiché en haut au centre de l'écran, en grand, avec un style visible (blanc avec ombre portée).
- Le score est visible uniquement pendant les phases "playing" et "dying".

### US4 — Écran de Game Over
**En tant que** joueur,
**je veux** voir un écran de game over avec mon score et pouvoir rejouer,
**afin de** recommencer facilement.

**Critères d'acceptation :**
- L'écran apparaît en fondu (fade in) par-dessus le jeu figé.
- Il affiche le texte "Game Over".
- Il affiche le score final de la partie.
- Il contient un bouton "Rejouer" (ou "Tap to restart").
- Appuyer sur "Rejouer" réinitialise complètement le jeu : score à 0, oiseau repositionné, tuyaux réinitialisés, retour à l'état idle.

### US5 — Nouveau cycle de jeu (GamePhase)
**En tant que** joueur,
**je veux** que le jeu gère correctement les transitions entre les états,
**afin que** l'expérience soit fluide.

**Critères d'acceptation :**
- Les phases du jeu sont : `idle` → `playing` → `dying` → `gameOver` → `idle`.
- En `idle` : l'oiseau flotte, "Tap to start" est affiché.
- En `playing` : le jeu tourne normalement, le score est affiché.
- En `dying` : plus aucun input accepté, tout est figé sauf l'oiseau qui tombe.
- En `gameOver` : l'écran de game over est affiché avec fade in, le bouton rejouer ramène à `idle`.

## 3. Testing and Validation

### Tests unitaires
- **Collision** : Vérifier la détection de collision entre un rectangle (oiseau) et les rectangles (tuyaux) dans différentes positions (au-dessus, en dessous, dans le gap, sur le bord).
- **Score** : Vérifier que le score s'incrémente correctement quand l'oiseau dépasse un tuyau, et qu'un tuyau ne peut pas être compté deux fois.
- **GamePhase** : Vérifier les transitions d'état (idle → playing → dying → gameOver → idle).

### Tests manuels
- Jouer une partie complète sur Chrome, iOS et Android.
- Vérifier que la collision est visuellement cohérente (pas de mort "injuste").
- Vérifier que l'animation de chute est fluide.
- Vérifier que le fade in du game over est visible et agréable.
- Vérifier que le bouton rejouer fonctionne et réinitialise tout correctement.

### Critères de succès
- La hitbox de l'oiseau correspond visuellement à son sprite.
- Le score est lisible sur tous les écrans (responsive).
- Le cycle complet idle → play → die → game over → replay fonctionne sans bug.
