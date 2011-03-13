use ExtUtils::MakeMaker;
use File::Spec::Functions qw( catfile );

my $filename = "lib/Bundle/Personal/Kuniyoshi.pm";

my @modules = do {
    open my $FH, "<", $filename
        or die "Could not open a file[$filename] for read.[$!]";

    my @list;
    my $is_in_contents;

    while ( <$FH> ) {
        chomp( my $line = $_ );

        next
            unless $line;

        if ( 0 == index $line, "=head1 CONTENTS" ) {
            $is_in_contents = "yes";
        }
        else {
            undef $is_in_contents
                if 0 == index $line, "=head1 ";

            next
                unless $is_in_contents;

            my( $name ) = grep { $_ } split m{\s+}, $line;

            push @list, $name
                and next;
        }
    }

    close $FH
        or die "Could not close a file[$filename].[$!]";

    @list;
};

WriteMakefile(
    NAME              => 'Bundle::Personal::Kuniyoshi',
    VERSION_FROM      => $filename,
    PREREQ_PM         => {
        map { $_ => 0 } @modules,
    },
    ABSTRACT_FROM     => $filename,
    AUTHOR            => 'kuniyoshi kouji <kuniyoshi@cpan.org>',
);

