#!/bin/bash

input_file="ecos.org"  # Fichier source contenant tous les SDD
sdd_name=""            # Variable pour stocker le numéro du SDD
sdd_content=""         # Variable pour stocker le contenu du SDD

# Lire le fichier ligne par ligne
while IFS= read -r line; do
    # Détection du début d'un SDD
    if echo "$line" | grep -qE '^\* SDD-[0-9]+'; then
        # Sauvegarder le fichier précédent avant d'en commencer un nouveau
        if [[ -n "$sdd_name" ]]; then
            echo -e "$sdd_content" > "${sdd_name}.txt"
        fi

        # Extraire uniquement le numéro du SDD (ex: "001" de "SDD-001")
        sdd_name=$(echo "$line" | grep -oE 'SDD-[0-9]+' | sed 's/SDD-//')

        # Ajouter le titre dans le contenu du fichier
        sdd_content="$line\n"

    else
        # Transformer :TAG: en #TAG et supprimer les :SDD_<n° SDD>
        modified_line=$(echo "$line" | sed -E 's/:([A-Z]+):/#\1/g' | sed -E 's/([A-Z])\SDD_[0-9]+:/\1/g')
        sdd_content+="$modified_line\n"
    fi
done < "$input_file"

# Enregistrer le dernier fichier traité
if [[ -n "$sdd_name" ]]; then
    echo -e "$sdd_content" > "${sdd_name}.txt"
fi

echo "Fichiers SDD générés avec succès."

