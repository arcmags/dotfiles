## ~/.irssi/scripts/names.pl ::
# Prints all nicks in current channel on a single line in status window.

use strict;
use warnings;

my $channel = Irssi::active_win->{active};

if ($channel
  && (ref($channel) eq 'Irssi::Irc::Channel'
    || ref($channel) eq 'Irssi::Silc::Channel'
    || ref($channel) eq 'Irssi::Xmpp::Channel')
  && $channel->{'type'} eq 'CHANNEL'
  && ($channel->{chat_type} eq 'SILC' || $channel->{'names_got'}))  {

    my @nicklist = ();
    my $nicks = '';
    my $theme = Irssi::current_theme();
    my $network = $channel->{'server'}->{'chatnet'};

    foreach my $nick ($channel->nicks()) {
        push @nicklist, "$nick->{'nick'}";
    }
    @nicklist = sort @nicklist;

    for (@nicklist[-@nicklist..-2]) {
        $nicks .= "$_ ";
    }
    $nicks .= "$nicklist[-1]";

    Irssi::print($theme->format_expand("{channel $channel->{'name'}}: ")
      . $theme->format_expand("{server $channel->{'server'}->{'chatnet'}}: ")
      . $theme->format_expand("{nick $nicks}")
      . ' (' . scalar(@nicklist) . ' nicks)');
}
