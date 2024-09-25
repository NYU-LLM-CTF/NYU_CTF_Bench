var templates = ["note", "todos", "weather"];
var templateURLs = ["/api/note.php",
                    "/api/todos.php",
                    "/api/weather.php"];
var tilesDiv = $("#tiles");

function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

if (uid >= 0) {
    for (i = 0; i < templates.length; i++) {
        $("#tileType").append($("<option>", {value: templateURLs[i], text: capitalizeFirstLetter(templates[i])}));
    }

    // Get the list of tiles
    $.getJSON("/api/tiles.php?callback=?&uid="+uid, function(json) {
        // TODO: This can rearrange the tiles because of the async ops. Fix this
        $.each(json.tiles, function(i, tile) {
            // Get the data for the tile
            $.getJSON(tile.url+"?callback=?&uid="+uid, function(data) {
                // Then get the template and render it
                $.get("/template.php?template="+tile.template+".html", function(template) {
                    tilesDiv.append(Mustache.render($(template).filter("#template").html(), data));
                });
            });
        })
    });

    $("#addTile").click(function() {
        var url = $("#tileType").val();
        var template;
    
        for (i = 0; i < templates.length; i++) {
            if (url.includes(templates[i])) {
                template = templates[i];
                break;
            } 
        }
    
        $.post("/api/tiles.php", {"action": "add", "url": url, "template": template, "uid": uid}, function(data) {
            location.reload();
        });
    })

    $("body").on("click", "#saveNote", function(event) {
        var noteText = $("#noteText").val();
    
        $.post("/api/note.php", {"note": noteText, "uid": uid});
    })

    $("body").on("click", "#addTodo", function(event) {
        var todoText = $("#newTodoText").val();
        $(".todosDiv ul").append($("<li>", {text: todoText}));
        $.post("/api/todos.php", {"action": "add", "todo": todoText, "uid": uid});
        $("#newTodoText").val("");
    })
}

