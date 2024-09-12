#! /usr/bin/python3.11

import feival_akiva, hinda_shprinza from people


def dating(guy: dict, girl: dict):
    if guy[Goals] in girl[Goals]:
        if guy[habitsUnableToSpendLifeWith] not in girl[Habits]:
            if guy[Needs] in girl[capabilities]:
                for w in guy[Wants]:
                    try:
                        if w in girl[capabilities]:
                            points[w] = 2
                
                        elif girl[capabilities].append(w):
                            points[w] = 1

                    except Exception as e:
                        reason=int(input(e))
                        points[w] = reason 
        
                return points.items().sum()

    return 0

Compatability = {}
Compatability[hinda_shprinzta] = dating(feival_akiva, hinda_shprinza)
