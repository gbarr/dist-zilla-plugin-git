use 5.008;
use strict;
use warnings;

package Dist::Zilla::PluginBundle::Git;
# ABSTRACT: all git plugins in one go

use Moose;
use Class::MOP;

with 'Dist::Zilla::Role::PluginBundle';

sub bundle_config {
    my ($self, $section) = @_;
    my $class = ( ref $self ) || $self;
    my $arg   = $section->{payload};

    # bundle all git plugins
    my @names   = qw{ Check Commit Tag Push };

    my @config;

    for my $name (@names) {
        my $class = "Dist::Zilla::Plugin::Git::$name";
        Class::MOP::load_class($class);
        push @config, [ "$section->{name}/$name" => $class => $arg ];
    }

    return @config;
}


__PACKAGE__->meta->make_immutable;
no Moose;
1;
__END__

=for Pod::Coverage::TrustPod
    bundle_config

=head1 SYNOPSIS

In your F<dist.ini>:

    [@Git]
    changelog   = Changes             ; this is the default
    allow_dirty = dist.ini            ; see Git::Check...
    allow_dirty = Changes             ; ... and Git::Commit
    commit_msg  = v%v%n%n%c           ; see Git::Commit
    tag_format  = %v                  ; see Git::Tag
    tag_message = %v                  ; see Git::Tag
    push_to     = origin              ; see Git::Push


=head1 DESCRIPTION

This is a plugin bundle to load all git plugins. It is equivalent to:

    [Git::Check]
    [Git::Commit]
    [Git::Tag]
    [Git::Push]

The options are passed through to the plugins.
