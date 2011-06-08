use strict;
use warnings;
use Test::More;
use Plack::Response;

{
    my $res = Plack::Response->new;
    $res->code(200);
    $res->header("Foo:Bar" => "baz");
    $res->body("Hello");

    is_deeply $res->finalize, [ 200, [ 'Foo-Bar' => 'baz' ], ["Hello"] ];
}

{
    my $res = Plack::Response->new;
    $res->code(200);
    $res->header("Foo\000Bar" => "baz");
    $res->header("Qux\177Quux" => "42");
    $res->body("Hello");

    is_deeply $res->finalize, [ 200, [ 'Foo-Bar' => 'baz', 'Qux-Quux' => '42' ], ["Hello"] ];
}

{
    my $res = Plack::Response->new;
    $res->code(200);
    $res->header("X-LWS" => "Bar\r\n  true");
    $res->body("Hello");

    is_deeply $res->finalize, [ 200, [ 'X-LWS' => 'Bar true' ], ["Hello"] ];
}

{
    my $res = Plack::Response->new;
    $res->code(200);
    $res->header("X-CRLF" => "Foo\nBar\rBaz");
    $res->body("Hello");

    is_deeply $res->finalize, [ 200, [ 'X-CRLF' => 'FooBarBaz' ], ["Hello"] ];
}

{
    my $res = Plack::Response->new;
    $res->code(200);
    $res->header("X-CRLF" => "Foo\nBar\rBaz");
    $res->body("Hello");

    is_deeply $res->finalize, [ 200, [ 'X-CRLF' => 'FooBarBaz' ], ["Hello"] ];
}

done_testing;

