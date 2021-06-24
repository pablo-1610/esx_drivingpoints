Config = {
    basePoint = 12,

    trad = {
        ["no_player_nearby"] = "~r~Aucun joueur proche de vous!",
        ["usage"] = "~o~Utilisation: %s",
        ["invalid_ammount"] = "~r~Montant invalide",
        ["points_notify"] = "~y~Vous avez actuellement %s points !",
        ["points_no_points"] = "~r~Vous n'avez aucun points sur votre permis !",
        ["points_add_cmd"] = "/points_add (points)",
        ["points_add_notify_sender"] = "~g~Ajout de %s points effectué !",
        ["points_add_notify_receiver"] = "~g~Vous avez reçu %s points sur votre permis de conduire",
        ["points_add_exceed_max_points"] = "~r~L'ajout de %s points dépasse le seuil de points maximums possibles, opération abandonnée !",
        ["points_remove_cmd"] = "/points_remove (points)",
        ["points_remove_notify_sender"] = "~g~Retrait de points effectué !",
        ["points_remove_notify_receiver"] = "~g~Vous avez perdu %s points sur votre permis de conduire",
        ["license_suspended"] = "~r~Vous avez perdu tous vos points ! Votre permis a donc été suspendu !",
        ["not_allowed"] = "~r~Vous n'avez pas la permission de faire cela !",
        ["no_driving_license_other"] = "~r~Ce joueur n'a pas de permis !",
        ["no_points_remaining_other"] = "~r~Ce joueur n'a plus de points sur son permis !",
    },

    drivingLicense = "drive",

    getESX = "esx:getSharedObject",
    
    regulatorJobs = {
        "police",
        "sheriff"
    }
}

_U = function(index)
    return (Config.trad[index] or "[[invalid_translation]]")
end