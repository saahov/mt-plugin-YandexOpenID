#!/usr/bin/perl -w
# This software is licensed under the MIT License.
# 
# Copyright (c) 2009 Andrey Serebryakov

package MT::Plugin::YandexOpenId;

use MT;
use strict;
use base qw( MT::Plugin );
our $VERSION = '1.1';

require MT::Auth::Yandex;

my $plugin = MT::Plugin::YandexOpenId->new({
    key         => 'YandexId',
    id          => 'YandexId',
    name        => 'Яндекс.OpenID',
    description => "Авторизация комментаторов через Яндекс.",
    version     => $VERSION,
    author_name => "Andrey Serebryakov",
    author_link => "http://blogstudio.ru/",
    plugin_link => "http://code.google.com/p/mt-plugins/wiki/YandexOpenId",
});

sub instance { $plugin; }

MT->add_plugin($plugin);

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        commenter_authenticators => {
            'Yandex' => {
                class => 'MT::Auth::Yandex',
                label => 'Yandex',
                login_form_params => '$YandexId::MT::Auth::Yandex::commenter_auth_params',
                condition => '$YandexId::MT::Auth::Yandex::openid_commenter_condition',
                logo => 'plugins/YandexOpenId/images/yandex.png',
                logo_small => 'plugins/YandexOpenId/images/yandex_logo.png',
                login_form => <<YANDEX,
<form method="post" action="<mt:var name="script_url">">
<input type="hidden" name="__mode" value="login_external" />
<input type="hidden" name="openid_url" value="yandex.ru" />
<input type="hidden" name="blog_id" value="<mt:var name="blog_id">" />
<input type="hidden" name="entry_id" value="<mt:var name="entry_id">" />
<input type="hidden" name="static" value="<mt:var name="static" escape="html">" />
<input type="hidden" name="key" value="Yandex" />
<fieldset>
<mtapp:setting
	id="yandex_display"
	show_label="0">
</mtapp:setting>
<div class="actions-bar actions-bar-login">
    <div class="actions-bar-inner pkg actions">
		<img src="<mt:var name="static_uri">plugins/YandexOpenId/images/yandex-openid.gif" alt="Яндекс.OpenID" />
		<button type="submit" class="primary-button">Используя Яндекс.OpenID</button>
    </div>
</div>
<p style="margin-top:16px;"><img src="<mt:var name="static_uri">images/comment/blue_moreinfo.png" /> <a href="http://openid.yandex.ru/">Узнать больше о Яндекс.OpenID</a></p>
</fieldset>
</form>
YANDEX
            },
        },
    });
}

1;
__END__

