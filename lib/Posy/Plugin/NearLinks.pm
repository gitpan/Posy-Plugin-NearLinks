package Posy::Plugin::NearLinks;
use strict;

=head1 NAME

Posy::Plugin::NearLinks - Posy plugin to give links of articles in the current category.

=head1 VERSION

This describes version B<0.42> of Posy::Plugin::NearLinks.

=cut

our $VERSION = '0.42';

=head1 SYNOPSIS

    @plugins = qw(Posy::Core
		  Posy::Plugin::TextTemplate
		  ...
		  Posy::Plugin::EntryTitles
		  Posy::Plugin::LinkList
		  Posy::Plugin::NearLinks
		  ...
		  );

=head1 DESCRIPTION

This provides a method which can be called from the "head" flavour template
(if one is using the TextTemplate plugin).  This finds all the entries in
the current category, and their titles, and makes a list of links to them.

This depends on the L<Posy::Plugin::EntryTitles> plugin to get the titles
from the entries.
This depends on the L<Posy::Plugin::LinkList> plugin to make the actual
list of links.

=cut

=head1 Helper Methods

Methods which can be called from elsewhere.

=head2 near_links

    $links = $self->near_links(
	pre_list=>'<ul>',
	post_list=>'</ul>',
	pre_item=>'<li>',
	post_item=>'</li>'
	pre_active_item=>'<li><em>',
	post_active_item=>'</em></li>',
	item_sep=>"\n");

Generates a list of links of entries in the current category.

Options:

=over

=item pre_list

String to begin the list with.

=item post_list

String to end the list with.

=item pre_item

String to prepend to a non-active item.

=item post_item

String to append to a non-active item.

=item pre_active_item

String to prepend to an active item.

=item post_active_item

String to prepend to an active item.

=item item_sep

String to put between items.

=back

=cut
sub near_links {
    my $self = shift;
    my %args = (
		pre_list=>'<ul>',
		post_list=>'</ul>',
		pre_item=>'<li>',
		post_item=>'</li>',
		pre_active_item=>'<li><em>',
		post_active_item=>'</em></li>',
		item_sep=>"\n",
		@_
	       );

    my @labels;
    my %links;

    # go through all the files in the titles index
    while (my ($file_id, $title) =  each(%{$self->{titles}}))
    {
	if (($self->{files}->{$file_id}->{cat_id}
	     eq $self->{path}->{cat_id}) # category matches
	    and ($self->{files}->{$file_id}->{basename}
		 ne 'index') # don't include index entry-files
	   )
	{
	    push @labels, $title;
	    # make a link with the current flavour
	    my $link = '/' . $file_id . '.' . $self->{path}->{flavour};
	    $links{$title} = $link;
	}
    }
    # sort the labels alphabetically -- hey, it's as good an order as any
    @labels = sort @labels;

    return $self->link_list(
	labels=>\@labels,
	links=>\%links,
	%args);
} # near_links

=head1 INSTALLATION

Installation needs will vary depending on the particular setup a person
has.

=head2 Administrator, Automatic

If you are the administrator of the system, then the dead simple method of
installing the modules is to use the CPAN or CPANPLUS system.

    cpanp -i Posy::Plugin::NearLinks

This will install this plugin in the usual places where modules get
installed when one is using CPAN(PLUS).

=head2 Administrator, By Hand

If you are the administrator of the system, but don't wish to use the
CPAN(PLUS) method, then this is for you.  Take the *.tar.gz file
and untar it in a suitable directory.

To install this module, run the following commands:

    perl Build.PL
    ./Build
    ./Build test
    ./Build install

Or, if you're on a platform (like DOS or Windows) that doesn't like the
"./" notation, you can do this:

   perl Build.PL
   perl Build
   perl Build test
   perl Build install

=head2 User With Shell Access

If you are a user on a system, and don't have root/administrator access,
you need to install Posy somewhere other than the default place (since you
don't have access to it).  However, if you have shell access to the system,
then you can install it in your home directory.

Say your home directory is "/home/fred", and you want to install the
modules into a subdirectory called "perl".

Download the *.tar.gz file and untar it in a suitable directory.

    perl Build.PL --install_base /home/fred/perl
    ./Build
    ./Build test
    ./Build install

This will install the files underneath /home/fred/perl.

You will then need to make sure that you alter the PERL5LIB variable to
find the modules, and the PATH variable to find the scripts (posy_one,
posy_static).

Therefore you will need to change:
your path, to include /home/fred/perl/script (where the script will be)

	PATH=/home/fred/perl/script:${PATH}

the PERL5LIB variable to add /home/fred/perl/lib

	PERL5LIB=/home/fred/perl/lib:${PERL5LIB}

=head1 REQUIRES

    Posy
    Posy::Core
    Posy::Plugin::TextTemplate
    Posy::Plugin::EntryTitles
    Posy::Plugin::LinkList

    Test::More

=head1 SEE ALSO

perl(1).
Posy

=head1 BUGS

Please report any bugs or feature requests to the author.

=head1 AUTHOR

    Kathryn Andersen (RUBYKAT)
    perlkat AT katspace dot com
    http://www.katspace.com

=head1 COPYRIGHT AND LICENCE

Copyright (c) 2004-2005 by Kathryn Andersen

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Posy::Plugin::NearLinks
__END__
