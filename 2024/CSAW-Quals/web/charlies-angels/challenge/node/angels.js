const angels = [
    {
        name: "Jill Munroe",
        actress: "Farrah Fawcett-Majors",
        movie: "OG Charlie's Angels TV Series",
        talents: {
            "0": "Racecar Driving",
            "1": "Gun Wielding",
            "2": "Baking"
        }
    },
    {
        name: "Sabrina Duncan",
        actress: "Kate Jackson",
        movie: "OG Charlie's Angels TV Series",
        talents: {
            "0": "Intuition",
            "1": "Skiing",
            "2": "Gun Wielding"
        }
    },
    {
        name: "Kelly Garett",
        actress: "Jaclyn Smith",
        movie: "OG Charlie's Angels TV Series",
        talents: {
            "0": "Unarmed Combat",
            "1": "Gun Wielding",
            "2": "Roller Skating",
            "3": "Leadership"
        }
    },
    {
        name: "Kris Munroe",
        actress: "Cheryl Ladd",
        movie: "OG Charlie's Angels TV Series",
        talents: {
            "0": "Scuba Diving",
            "1": "Unarmed Combat",
            "2": "Bushcraft",
            "3": "Chemistry",
            "4": "Surfing",
            "5": "Roller Skating"
        }
    },
    {
        name: "Tiffany Welles",
        actress: "Shelley Hack",
        movie: "OG Charlie's Angels TV Series",
        talents: {
            "0": "Knot-tying",
            "1": "Latin",
            "2": "Truck-driving",
            "3": "Biology"
        }
    },
    {
        name: "Julie Rogers",
        actress: "Tanya Rogers",
        movie: "OG Charlie's Angels TV Series",
        talents: {
            "0": "Driving",
            "1": "Scuba Diving",
            "2": "Modelling"
        }
    },
    {
        name: "Natalie Cook",
        actress: "Cameron Diaz",
        movie: "Charlies Angels: Full Throttle",
        talents: {
            "0": "Unarmed Combat",
            "1": "Driving",
            "2": "Helicopter Piloting",
            "3": "Disguise"
        }
    },
    {
        name: "Dylan Sanders",
        actress: "Drew Barrymore",
        movie: "Charlies Angels: Full Throttle",
        talents: {
            "0": "Unarmed Combat",
            "1": "Disguise",
            "2": "Wrestling",
            "3": "Mongolian",
            "4": "Spanish"
        }
    },
    {
        name: "Alex Munday",
        actress: "Lucy Liu",
        movie: "Charlies Angels: Full Throttle",
        talents: {
            "0": "Unarmed Combat",
            "1": "Strategist",
            "2": "Safe Cracking",
            "3": "Bomb Defusal",
            "4": "Aerospace Engineering",
            "5": "Chess",
            "6": "Gymnastics",
            "7":"Archery",
            "8": "Horseriding"
        }
    },
    {
        name: "Sabina Wilson",
        actress: "Kristen Stewart",
        movie: "Charlie's Angels (2019)",
        talents: {
            "0": "Unarmed Combat",
            "1": "Acrobatics",
            "2": "Gun Wielding",
            "3": "Horseriding"
        }
    },
    {
        name: "Jane Kano",
        actress: "Ella Balinska",
        movie: "Charlie's Angels (2019)",
        talents: {
            "0": "Unarmed Combat",
            "1": "Gun Wielding",
            "2": "Tactics"
        }
    },
    {
        name: "Elena Houghlin",
        actress: "Naomi Scott",
        movie: "Charlie's Angels (2019)",
        talents: {
           "0":  "Hacking"
        }
    }

];

module.exports.randomAngel = () => {
    return angels[Math.floor(Math.random() * angels.length)];
};;