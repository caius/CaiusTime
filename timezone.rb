require "rubygems"
require "sinatra"
require "caius_time"

helpers do
  def pluralize amount, string
    amount == 1 ? "#{amount} #{string}" : "#{amount} #{string.pluralize}"
  end
end

get "/" do
  @ct = CaiusTime.new(:settings => settings)
  @ct.run!
  erb :index
end


__END__
@@ layout
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>UTC<%= @ct.offset %> :: Caius Time</title>

    <style type="text/css" media="screen">
      body {
        margin: 3em auto;
        text-align: center;
        font-size: 200%;
        width: 13em;
        font-family: Helvetica, sans-serif;
      }

      body > h1 {
        margin-bottom: 0.15em;
      }

      body > h2,
      body > p {
        margin: 0.5em auto;
      }

      p.padded {
        margin-top: 0.75em;
      }

      hr {
        margin-top: 3em;
      }

      dl {
        font-size: 35%;
        text-align: left;
      }

      dt {
        font-weight: bold;
        margin-top: 0.5em;
      }

    </style>

  </head>
  <body>
    <h1>Caius Time</h1>
    <%= yield %>
  </body>
</html>

@@ index
<p>is currently</p>

<% if @ct.time %>
  <%= erb :time, :layout => false %>
<% else %>
  <%= erb :asleep, :layout => false %>
<% end %>

<hr />

<dl>
  <dt>Why?</dt>
  <dd>
    <a href="http://caius.name/">Caius</a> doesn't stay on the UK timezone all that well, and is usually off by a couple of hours. He's been as bad as GMT-1300 before now!
  </dd>

  <dt>How?</dt>
  <dd>
    Finds my earliest tweet of the current day and work out the offset from that to 9am (start of <em>typical</em> working day) to within the nearest hour.
  </dd>

  <dt>A Myth?</dt>
  <dd>It's a myth if we can't work it out for some reason. It's quite likely he is just asleep and hasn't woken up yet today, lazy bastard that he is.</dd>
</dl>

@@ time
<h2>UTC <%= @ct.offset %></h2>

<!-- <p><%= @ct.time.to_s(:long_ordinal) %></p> -->

<p class="padded">
  <em>
    <% if @ct.diff == 0 %>
      (Bang on UK time)
    <% else %>
      (<%= pluralize(@ct.diff.abs, "hour") %> <%= @ct.diff.abs == @ct.diff ? "behind" : "ahead of" %> the UK)
    <% end %>
  </em>
</p>

@@ asleep
<h2>a myth</h2>
