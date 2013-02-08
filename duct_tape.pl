#!/usr/bin/env perl

use Mojolicious::Lite;

# Simple plain text response
get '/' => {text => 'Здравей Свят!'};

# Route associating "/time" with template in DATA section
get '/time' => 'clock';

# RESTful web service with JSON and text representation
get '/list/:offset' => sub {
  my $self    = shift;
  my $numbers = [0 .. $self->param('offset')];
  $self->respond_to(
    json => {json => $numbers},
    txt  => {text => join(',', @$numbers)}
  );
};

# Scrape information from remote sites
get '/title' => sub {
  my $self = shift;
  my $url  = $self->param('url') || 'http://mojolicio.us';
  $self->render_text(
    $self->ua->get($url)->res->dom->html->head->title->text);
};

# WebSocket echo service
websocket '/echo' => sub {
  my $self = shift;
  $self->on(message => sub {
    my ($self, $msg) = @_;
    $self->send("Ехо: $msg");
  });
};
# Client for the WebSocket echo service 
get '/echo' => 'echo';

app->start;
__DATA__

@@ clock.html.ep
% use Time::Piece;
% my $now = localtime;
The time is <%= $now->hms %>.

@@ echo.html.ep
<!DOCTYPE html>  
<html>  
<head>  
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<title>Уеб-Сокет Клиент</title>
<body>
  <div id="container">  
    <h1>Уеб-Сокет Клиент</h1>  
    <div id="chatLog" 
      style="border:1px solid #999; height:6em; overflow:auto">  
    </div><!-- #chatLog -->  
    <p id="examples">Да опитаме 'здрасти', 'име', 'възраст', 'чао'</p>  
    <input id="text" type="text" />  
    <button id="disconnect">Край</button>
  </div><!-- #container -->
  <div style="font-size:x-small">Примерът е адаптиран от 
http://net.tutsplus.com/tutorials/javascript-ajax/start-using-html5-websockets-today/
  </div>
  <script>

$(document).ready(function() {
  if(!("WebSocket" in window)){
  $('#chatLog, input, button, #examples').fadeOut("fast");
  $('<p>О не. Трябва ви браузър поддържащ Уеб-Сокети.'+
    'Пробвайте <a href="http://www.mozilla.org/bg/firefox/fx/">'+
    'Firefox</a>!</p>').appendTo('#container');
  }else{
      //The user has WebSockets
      connect();
  }//End else
});
function connect(){
    var socket;
    var host = "ws://127.0.0.1:3000/echo";
    try{
        var socket = new WebSocket(host);
        message('<p class="event">Стаус на сокета: '+socket.readyState);
        socket.onopen = function(){
         message('<p class="event">Стаус на сокета: '+socket.readyState+' (open)');
        }
        socket.onmessage = function(msg){
         message('<p class="message">Получено: '+msg.data);
        }
        socket.onclose = function(){
          message('<p class="event">Стаус на сокета: '+socket.readyState+' (Затворен)');
        }
    } catch(exception){
       message('<p>Грешка'+exception);
    }
    function send(){
        var text = $('#text').val();
        if(text==""){
            message('<p class="warning">Моля, въведете съобщение!');
            return ;
        }
        try{
            socket.send(text);
            message('<p class="event">Изпратено: '+text)
        } catch(exception){
           message('<p class="warning">');
        }
        $('#text').val("");
    }
    function message(msg){
      $('#chatLog').prepend(msg+'</p>');
    }
    $('#text').keypress(function(event) {
        if (event.keyCode == '13') {//Enter
          send();
        }
    });
    $('#disconnect').click(function(){
       socket.close();
    });
}//End connect
  </script>
</body>
</html>