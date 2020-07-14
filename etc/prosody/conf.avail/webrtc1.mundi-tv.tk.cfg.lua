plugin_paths = { "/usr/share/jitsi-meet/prosody-plugins/" }

-- domain mapper options, must at least have domain base set to use the mapper
muc_mapper_domain_base = "webrtc1.mundi-tv.tk";

turncredentials_secret = "Yi08YU6TNiAC9b7O";

turncredentials = {
  { type = "stun", host = "webrtc1.mundi-tv.tk", port = "4446" },
  { type = "turn", host = "webrtc1.mundi-tv.tk", port = "4446", transport = "udp" },
  { type = "turns", host = "webrtc1.mundi-tv.tk", port = "4445", transport = "tcp" }
};

cross_domain_bosh = false;
consider_bosh_secure = true;
-- https_ports = { }; -- Remove this line to prevent listening on port 5284

VirtualHost "webrtc1.mundi-tv.tk"
        -- enabled = false -- Remove this line to enable this host
        -- authentication = "anonymous"
        -- Properties below are modified by jitsi-meet-tokens package config
        -- and authentication above is switched to "token"
        --app_id="example_app_id"
        --app_secret="example_app_secret"
        -- Assign this host a certificate for TLS, otherwise it would use the one
        -- set in the global section (if any).
        -- Note that old-style SSL on port 5223 only supports one certificate, and will always
        -- use the global one.
        ssl = {
                key = "/etc/prosody/certs/webrtc1.mundi-tv.tk.key";
                certificate = "/etc/prosody/certs/webrtc1.mundi-tv.tk.crt";
        }
        speakerstats_component = "speakerstats.webrtc1.mundi-tv.tk"
        conference_duration_component = "conferenceduration.webrtc1.mundi-tv.tk"
        -- we need bosh
        modules_enabled = {
            "admin_web";
            "bosh";
            "pubsub";
            "ping"; -- Enable mod_ping
            "speakerstats";
            "turncredentials";
            "conference_duration";
        }
        c2s_require_encryption = false

Component "conference.webrtc1.mundi-tv.tk" "muc"
    storage = "none"
    modules_enabled = {
        "muc_meeting_id";
        "muc_domain_mapper";
        -- "token_verification";
    }
    admins = { "focus@auth.webrtc1.mundi-tv.tk" }
    muc_room_locking = false
    muc_room_default_public_jids = true

-- internal muc component
Component "internal.auth.webrtc1.mundi-tv.tk" "muc"
    storage = "none"
    modules_enabled = {
      "ping";
    }
    admins = { "focus@auth.webrtc1.mundi-tv.tk", "jvb@auth.webrtc1.mundi-tv.tk" }
    muc_room_locking = false
    muc_room_default_public_jids = true

VirtualHost "auth.webrtc1.mundi-tv.tk"
    ssl = {
        key = "/etc/prosody/certs/auth.webrtc1.mundi-tv.tk.key";
        certificate = "/etc/prosody/certs/auth.webrtc1.mundi-tv.tk.crt";
    }
    authentication = "internal_plain"

Component "focus.webrtc1.mundi-tv.tk"
    component_secret = "ramkmd3d"

Component "speakerstats.webrtc1.mundi-tv.tk" "speakerstats_component"
    muc_component = "conference.webrtc1.mundi-tv.tk"

Component "conferenceduration.webrtc1.mundi-tv.tk" "conference_duration_component"
    muc_component = "conference.webrtc1.mundi-tv.tk"
Component "callcontrol.webrtc1.mundi-tv.tk" component_secret = "pbTUfTM#"
