# tac_plus.conf

```
tac_plus.conf(5)                               File Formats Manual                               tac_plus.conf(5)

NAME
       tac_plus.conf - tacacs+ daemon configuration file

DESCRIPTION
       This page is a work in progress.

       tac_plus.conf contains configuration information for the tac_plus (tacacs+) daemon.

       Each  line  contains  either  one  of  the directives documented below, white-space (blanks or tabs), or a
       comment.

       Syntax enclosed in angle brackets (<>) below, refer to syntax documented elsewhere in this manual page.

TOP-LEVEL DIRECTIVES
       #      Comments begin with a '#' character and extend to  the  end  of  the  line.   Comments  may  appear
              anywhere  in  the configuration file.  To disable the special meaning of the '#' character, enclose
              the string containing it in double quotes ("#").

       accounting
              Only one configurable account parameter exists, the destination.  All accounting records are either
              written to a file, syslog(3) at priority info, or both.

                  accounting syslog;
                  accounting file = <filename>

              The default filename is /var/log/tac_plus.acct.

              Since  accounting  requests  occur  (and  are serviced) asynchronously, it is necessary to lock the
              accounting file so that two writers do not simultaneously write to it.  The daemon uses fcntl(2) to
              lock  the  file.   Although  fcntl(2)  locking over NFS is supported on some implementations, it is
              notoriously unreliable.  Even if it is reliable, locking is likely to be extremely inefficient over
              NFS.  The file is best located on a local file system.

       acl    If  compiled  with acl support (--enable-acls), Access Control Lists can be defined to limit user's
              (or group's) login and/or enable access by daemon  client  IP  address  or  hostname.   An  acl  is
              referenced by its name, but must be defined before it can be referenced.

              The  acl  is a series of permit or deny statements applied to the source IP address that the client
              used to connected to the daemon.  The first <regex> that matches ends the evaluation and the result
              is  the  permit  or deny on left.  If no entry of the acl matches a given address, the result is an
              implicit deny.

                  acl = <name> {
                      <permission> = <regex>

                      # deny 66.1.255/24, allow all else in 66.1/16
                      deny = ^66\.1\.255\.
                      permit = ^66\.1\.
                      # implicit deny (ie: anything else)
                  }

              Briefly, if a company had all their loopback interfaces numbered from 66.1/16  (and  thus  all  the
              tacacs  clients  are  within  66.1/16),  this acl might be used to dis-allow a user to login to (or
              enable on) any router whose loopback interface is in 66.1.255/24.

              Note: because acls match against the daemon client's  source  IP  address,  the  client  should  be
              configured to use a stable source such as a loopback interface.  For example:
                  ip tacacs-server source-interface loopback 0

       default authentication
              By  default,  authentication  fails  for  users that do not appear in the configuration file.  This
              overrides that behavior, thus permitting all authentication requests for such users.

                  default authentication = file <filename>

              Such users will be authentication via the <user> "DEFAULT".

              Also see "user = DEFAULT", <default service>, and <default attribute>.

       group  Analogous to a <user> and accepting the same syntax, a group provides a template of which a  <user>
              or another group can be a member.

                  group = <name> {
                      <user_decl>
                  }

              A group may be recursive; that is a group may be a member of one other group (which may be a member
              of yet another group, and so on).

       host   The host clause allows the configuration values noted below to be set for the client  named  by  IP
              address.  If tac_plus is started with the -L option, the name can also be name as resolved from the
              address with the gethostbyaddr(3) system call, which may be the FQDN (Fully Qualified Domain  Name)
              if  DNS  is used.  It is recommended that the IP address be used, since the resolver can be slow to
              timeout when network faults exist.

                  host = <IP address> {
                   key = <string>
                   prompt = <string>
                   enable = <password_spec>
                  }

              key specifics the packet encryption <key> for this host.

              prompt specifies the username prompt that will be presented to a user.

       key    Specifies an encryption key used to encrypt packets between the daemon and clients.  This key  must
              match the key configured on the clients.

              key = <string>

              The  double  quotes  are  only  necessary  if  your key contains white-space, key-words, or special
              characters.

              Note: encryption is highly recommended.

       logging
              Specifies the syslog(3) facility used.  By default, logs are posted to the daemon facility.

                  logging = <syslog_fac>

       user   Define a user whose username is <name>.

                  user = <name> {
                      [ <default service> ]
                      <user_attr>
                      <svc>
                  }

              Note: seventeen special usernames exist:  "DEFAULT",  "$enable$",  and  "$enabN$"  (where  N  is  a
              privilege  level  number,  normally  in  the  range  0-15  on a Cisco).  The "$enable$" user is for
              backward compatibility with previous versions of tacacs that is queried for privilege level  15  in
              addition to "$enab15$".

              Also  see  the  "priv-lvl" AV pair in the "AV Pairs" section below and the <default authentication>
              directive.

       service
                  user = <string> {
                      [ default service = <permission> ]
                      <user_attr>*
                      <svc>*
                  }

              Also see the <default service> directive.

ADDITIONAL DIRECTIVE SYNTAX
       attr_value_pair
              Specify an AV (Attribute Value) pair.  The  "optional"  keyword  specifies  that  the  AV  pair  is
              optional.

                  [ optional ] <string> = <string>

              Optional  AV  pairs are only sent to the client if it requests them.  That is, the client must have
              included the given AV pair as a mandatory or optional pair in the request.

              Some clients react incorrectly and negatively to receiving  AV  pairs  that  it  did  not  solicit.
              Optional  AV  pairs  should  be  ignored  if  they are not recognized or not supported in any given
              context.

              Also see the "Configuring Authorization" and "AV Pairs" sections below.

       cmd_auth
              Specify command authorization.

              For command authorization, the device should expand all abbreviated commands to  their  full  names
              and  compress adjacent white-space.  For example, when the command "config t" is entered it will be
              expanded to "configure terminal".

                  cmd = <string> {
                      <cmd-match>
                  }

       cmd-match
              Specify a command argument match.

                  <permission> <regex>
                  <permission> <regex>
                   ...
                  <permission>

              The <regex> matches arguments of the command <string>.  For example, to  allow  show  diag  but  no
              other show commands:

                  cmd = show {
                      permit diag
                      deny
                  }

              The  end  of  the <cmd-match> has an implicit <permission> determined by <default service>.  So, if
              the 'deny' had been omitted in the example above, the result of  the  authorization  would  be  the
              value of <default service>.

              Note:  'cmd-arg'  should never appear in a configuration file.  It is used internally by the daemon
              to construct a string which is then matched against the regular expressions which appear in  a  cmd
              clause in the configuration file.

              Note:  when  a  command has multiple arguments, they may be entered in many different permutations.
              It can be cumbersome to create regular expressions which will  reliably  authorize  commands  under
              these conditions.  Administrators may wish to consider other methods of performing authorization.

       default service
              Specifies the default <permission> for service authorization.

                  default service = <permission>

              If omitted, the default is 'deny'.

              Note: if used, <default service> must precede all other <svc> directives in a <user> clause.

       default attribute
              Specifies the default attribute <permission> for service authorization.

                  default attribute = <permission>

              Note: if used, <default attribute> must precede all other <svc_attr> directives in a <svc> clause.

       des_string
              Represents the one-way encryption of a password <string>.  For example, a password might encrypt to
              the string 0AmUKnIT2gheo.

              DES is the encryption historically used in Unix passwd(5)  files.   The  crypt()  function  of  the
              system's  libcrypt  is  used  to  perform  the  encryption.  The libcrypt of modern Unicies tend to
              support additional encryption algorithms and thus so would tac_plus.  See the system's crypt manual
              page.   To  utilize  another  format,  use  the  des keyword followed by the crypt in the format as
              described in the manpage.  Typically it will have a "$1" prefix for MD5, "$2" for blowfish, and  so
              on.

              tac_pwd(8) is a utility supplied with tac_plus to assist in performing this encryption.

       expires
              Causes the <user>'s password to become invalid, starting on the specified expiration date.

                  expires "May 23 2005"

              A  expiry  warning  message  is  sent  to  the  user  at login time, starting at 14 days before the
              expiration date.

              If the <user>'s <login> <password_spec> is "file", the "expires" field of the configuration file is
              not consulted.  Instead, the daemon looks at the the "shell" field of the password file entry for a
              valid expiration date.

              If Solaris shadow  password  files  are  used  for  authentication,  the  "expires"  field  of  the
              configuration  file is not consulted. The expiry field from the shadow password file (if it exists)
              is used as the expiration date.

              Case is not significant.

       filename
              A <string> specifying a file located in the filesystem.

              While the daemon does change directories to / (root) when it starts, it is best to specify files by
              their  FQPN  (Fully  Qualified  Path  Name).   That  is,  a  path that begins with /.  For example,
              /var/log/file rather than the relative path var/log/file.

       IP address
              A <string> representing an IPv4 address in dotted-quad notation.  For example:

                  192.168.1.1

       name   A <string> by which to refer to a configuration element, such as an <acl> or a <group>.

              In general, a <name> must be defined before it can be referenced.  For example, before a <user> can
              be a specified as a member of a <group>, the <group> has to be defined.

       password_spec
              There  are  five  authentication  mechanisms available: no password, cleartext, DES, PAM, a file in
              passwd(5) format, and skey.

                  file <filename>
                  cleartext <string>
                  des <des_string>
                  PAM
                  skey
                  nopassword

              skey is an OTP (One Time Password) facility.  The daemon must be built  with  skey  (--enable-skey)
              support.

              PAM  (Pluggable  Authentication  Modules  framework) is an authentication mechanism (and much more)
              capable of various types of authentication methods that are chosen by a  configuration  file.   The
              PAM service name is the name of tac_plus executable, normally "tac_plus".  PAM can be used only for
              login authentication, it is not implemented for enable authorization, and does not support OTP-like
              challenge  system  (ie: no additional prompting).  The daemon must be built with PAM support, which
              is included by default if libpam is found.

              Note: some cases of <password_spec> do not accept all of these mechanisms.

       permission
              Specifies that some match (for example a <service> or <cmd-match>) is to be allowed or denied.

                  (permit | deny)

       proto  A protocol is a subset of a service.  Typical NAS supported values are atalk, bap,  bridging,  ccp,
              cdp,  deccp,  ip,  ipx,  lat, lcp, multilink, nbf, osicp, pad, rlogin, telnet, tn3270, vines, vpdn,
              xns, xremote, and unknown.  Note that 'protocol' is actually an AV pair.

       string A series of characters, not including white-space or tac_plus key-words or special characters  (ie:
              A-Za-z0-9_).   To  include  any of those exceptions, enclose the string in double quotes ("this has
              whitespace").

       svc         XXX:

                  <svc_auth> | <cmd_auth>

       svc_auth
                   XXX:            service  =  (  arap  |  connection  |  exec  |  ppp  protocol  =   <proto>   |
                             shell   |  slip  |  system  |  tty-daemon  |  <client  defined>  )                 {
                             [ <default attribute> ]
                                      <attr_value_pair>*
                                  }

              The service AV pair is required.

       syslog_fac
              syslog(3) normally has 16 well-known channels, called facilities.  syslogd(8) can be configured  to
              direct  each of these facilities to different files.  The facilities are named: auth, cron, daemon,
              local[0-7], lpr, mail, news, syslog, user, and uucp.

       user_attr
                   XXX:

                  user = bart {
                      arap = cleartext "arap password"
                      chap = cleartext "chap password"
                      enable = <password_spec>
                      pap  = cleartext "inbound pap password"
                      opap = cleartext "outbound pap password"
                      pap  = des <des_string>
                      pap  = file <filename>
                      pap  = PAM
                      login = <password_spec>
                      global = cleartext "outbound pap password"
                  }

              global specifies the authentication method for  all  services.   login  applies  to  normal  logins
              (exec).  arap, chap, pap, and opap (outbound PAP) service passwords may be defined separately.

              NOTE:  a  global  user  password  cannot  be used for outbound PAP. This is because outbound PAP is
              implemented by sending the password from the daemon to the client. This is a security issue if  the
              <key> is ever compromised.

              enable  specifies  the  enable  password.   The <password_spec> may only be of type cleartext, des,
              nopassword or file.  If the daemon was compiled with per-user  enable  support  (--enable-uenable),
              the host enable password will be evaluated iff the user does not have a personal enable password.

              login name member    - can only be 1 default service = permit expires "May 23 2005"
                  arap = cleartext "Fred's arap secret"
                  chap = cleartext "Fred's chap secret" acl = <string> enableacl = <string>

              In  the  case of recursion, the first match is returned.  host enable is cleartext, des, nopassword
              or file only.  arap chap expires May 23 2005 login member password      user_attr :=           name
              = <string> |
                                       login    = <password_spec> |
                                       member   = <string> |
                                       expires  = <string> |
                                       arap     = cleartext <string> |
                                       chap     = cleartext <string> |      #ifdef MSCHAP
                                       ms-chap  = cleartext <string> |      #endif
                                       pap      = cleartext <string> |
                                       pap      = des <string> |
                                       pap      = file <filename> |      #ifdef PAM
                                       pap      = PAM |      #endif
                                       opap     = cleartext <string> |
                                       global   = cleartext <string> |
                                       msg      = <string>
                                       before authorization = <string> |
                                       after authorization = <string>

CONFIGURING AUTHORIZATION
       Authorizing  a  single  session can result in multiple requests being sent to the daemon.  For example, to
       authorize a dialin ppp user for IP, the following authorization requests would be made from the client:

       1)     An initial authorization request to startup ppp from the  exec,  using  the  AV  pairs  service=ppp
              protocol=ip, will be made (Note: this initial request will be omitted if you are autoselecting ppp,
              since username will not be known yet).

              This request is really done to find the address for dumb  PPP  (or  SLIP)  clients  who  cannot  do
              address  negotiation.  Instead,  they expect you to tell them what address to use before PPP starts
              up, via a text message.

       2)     Next, an authorization request is made from the  PPP  subsystem  to  see  if  ppp's  LCP  layer  is
              authorized.  LCP  parameters  can be set at this time (e.g. callback). This request contains the AV
              pairs service=ppp protocol=lcp.

       3)     Next an authorization request to startup ppp's IPCP layer is made using the  AV  pairs  service=ppp
              protocol=ipcp. Any parameters returned by the daemon are cached.

       4)     Next,  during  PPP's  address  negotiation  phase,  each  time  the remote peer requests a specific
              address, if that address isn't in the cache obtained in step 3, a new authorization request is made
              to see if the peers requested address is allowable.  This step can be repeated multiple times until
              both sides agree on the remote peer's address or until the NAS (or  client)  decide  they're  never
              going to agree and they shut down PPP instead.

       As  you  can  see  from  the above, a program which plans to handle authorization must be able to handle a
       variety of requests and respond appropriately.

       Authorization must be configured on both the client and the daemon to operate correctly.  By default,  the
       client will allow everything until configured to make authorization requests to the daemon.

       With  the  daemon,  the  opposite is true; by default, the daemon will deny authorization of anything that
       isn't explicitly permitted.

       Authorization allows the daemon to deny commands and services outright, or to modify commands and services
       on  a  per-user  basis.   Authorization  on  the  daemon  is divided into two separate parts: commands and
       services.

       Authorizing:

       commands
              Exec commands are those commands which are typed at a Cisco  exec  prompt.  When  authorization  is
              requested by the NAS, the entire command is sent to the daemon for authorization.

              Command authorization is configured by specifying a list of <regex>s to match command arguments and
              an action which is a <permission>.

              The following permits user Fred to run these commands:

                  telnet 131.108.13.<any number> and
                  telnet 128.<any number>.12.3 and
                  show <anything>

              All other commands are denied (by default).

                  user=fred {
                      cmd = telnet {
                          # permit specified telnets
                          permit 131\.108\.13\.[0-9]+
                          permit 128\.[0-9]+\.12\.3
                      }
                      cmd = show {
                          # permit show commands
                          permit .*
                      }
                  }

              The command and arguments which the user types are matched to the regular expressions specified  in
              the  configuration  file  (in  order  of  appearance).   The  first  successful  match performs the
              associated action (<permission>). If there is no match, the command is denied by default.

              Also see the <default authentication>, <default authorization>, <default attribute>,  and  <default
              service> directives.

AUTHORIZATION SCRIPTS
       There are some limitations to the authorization that can be done using a configuration file.  One solution
       is to arrange for the daemon to call user-supplied programs to  control  authorization.  These  "callouts"
       permit  almost  complete  control  over  authorization,  allowing  you  to  read  all  the  fields  in the
       authorization packet sent by the client, including all its AV pairs, and to set authorization  status  and
       send a new set of AV pairs to the client in response.

       Pre  and  post authorization programs are invoked by handing the command line to the Bourne shell. On most
       Unix systems, if the shell doesn't find the specified program it returns a status  of  one,  which  denies
       authorization.  However,  at  least  one  Unix  system  (BSDI)  returns  a  status  code  of 2 under these
       circumstances, which will permit authorization, and probably isn't what you intended.

       Note: if your program hangs, the authorization will time out and return an error on the client, and you'll
       tie up a process slot on the daemon host, eventually running out of resources. There is no special code to
       detect this in the daemon.

       The daemon communicates with pre and post (before and after) authorization programs over a pair of  pipes.
       Programs  using  the standard i/o library will use full buffering in these circumstances.  This should not
       be a problem, since AV pairs will be read until end of file (EOF) is seen on input,  and  output  will  be
       flushed when they exit.

       Fields  from  the authorization packet can be supplied to the programs as arguments on the command line by
       using the appropriate dollar-sign variables in the configuration file.  These fields are:

           user    -- user name
           name    -- client/NAS name
           ip      -- client/NAS IP
           port    -- client/NAS port
           address -- user address (remote user location)
           priv    -- privilege level number (0-15)
           method  -- a digit (1-4)
           type    -- digit (1-4)
           service -- digit (1-7)
           status  -- (pass, fail, error, unknown)

       Unrecognized variables will appear as the string "unknown".

       AV pairs from the authorization packet are fed to the program's standard input, one per line. The  program
       is expected to process the AV pairs and write them to its standard output, one per line. What happens then
       is determined by the exit status of the program.

       Note: when AV pairs containing spaces are listed in the configuration file, you need to  enclose  them  in
       double  quotes  so  that they are parsed correctly. AV pairs which are returned via standard output do not
       need delimiters and so should not be enclosed in double quotes.

       Note: unless special arrangements are made, the daemon will run as root and hence the programs it  invokes
       will  also  run as root, which is a security weakness. It is strongly recommended that FQPNs are used when
       specifying programs to execute, and that the daemon is compiled  with  unprivileged  user  and  group  IDs
       (--with-userid and --with-groupid) so that the daemon is not running as root when calling these programs,

       Calling scripts

       before authorization
              Specify  a  per-user program to be called before any other authorization attempt is made by using a
              "before" clause.

                  user = auth1 {
                      before authorization "/path/pre_authorize $user $port $address"
                  }

              The AV pairs sent from the NAS will be supplied to the program standard input, one pair per line.

              If the program returns a status of  0,  authorization  is  unconditionally  permitted.  No  further
              processing is done on this request and no AV pairs are returned to the client.

              If  the  program  returns  a  status  of  1,  authorization  is  unconditionally denied. No further
              processing is done on this request and no AV pairs are returned to the client.

              If the program returns a status of 2, authorization is  permitted.   The  program  is  expected  to
              modify  the AV pairs that it receives on its standard input (or to create entirely new ones) and to
              write them, one per line, to its standard output. The new AV pairs will be sent to the client  with
              a status of AUTHOR_STATUS_PASS_REPL.  No further processing takes place on this request.

              If  the  program returns a status of 3, authorization is denied, but all attributes returned by the
              program via stdout are returned to the client. Also, whatever the  program  returns  on  stderr  is
              placed into the server-msg field and returned to the client.

              Any other status value returned from the program will cause an error to be returned to the client.

              Note: a status of 2 is not acceptable when doing command authorization.

       after authorization
              Specify  a  per-user  program to be called after authorization processing has been performed by the
              default, but before the authorization status and AV pairs have been transmitted to the  client,  by
              using a "after" clause.

                  group = auth1 {
                      after authorization "/path/post_authorize $user $port $status"
                  }

              The  AV  pairs resulting from the authorization algorithm that the daemon proposes to return to the
              NAS, are supplied to the program on standard input, one AV pair per line, so they can  be  modified
              if required.

              The  program  is  expected  to  process the AV pairs and write them to its standard output, one per
              line. What happens then is determined by the exit status of the program:

              If the program returns a status of 0, authorization continues as if  the  program  had  never  been
              called.   Use  this  if  (for  example)  to  just  send  mail when an authorization occurs, without
              otherwise affecting normal authorization.

              If the program returns a status of 1, authorization is unconditionally  denied.  No  AV  pairs  are
              returned to the NAS. No further authorization processing occurs on this request.

              If the program returns a status of 2, authorization is permitted and any AV pairs returned from the
              program on its standard output are sent to the NAS in place of any AV pairs  that  the  daemon  may
              have constructed.

              Any other value will cause an error to be returned to the NAS by the daemon.

       Current attributes are:

           "unknown"
           "service"
           "start_time"
           "port"
           "elapsed_time"
           "status"
           "priv_level"
           "cmd"
           "protocol"
           "cmd-arg"
           "bytes_in"
           "bytes_out"
           "paks_in"
           "paks_out"
           "address"
           "task_id"
           "callback-dialstring"
           "nocallback-verify"
           "callback-line"
           "callback-rotary"

       Also see the "AV Pairs" section below.

AV PAIRS
       AV  (Attribute  Value)  pairs  are  text  strings  exchanged  between  the  client  and server of the form
       "attribute=value".  The value may not appear in authorization request packets, indicating that it is  null
       or  unspecified.   The  equal  sign ('=') means that this is a mandatory attribute.  An asterisk ('*') may
       appear in place of the equal sign, indicating that it is an optional attribute which either the client  or
       server may not understand or may ignore.

       Optional attributes are preceded by the "optional" key-word in the configuration.  For example:

           priv_lvl = 15
           optional allow-shell = true

           service=ppp
           protocol=ip
           addr*131.108.12.44

       The  following  AV  pairs  specify  which  service  is being authorized. They are typically accompanied by
       protocol AV pairs and other, additional pairs from the lists below.

       service=arap

       service=shell       for exec startup, and also for command authorizations.  Requires:

                               aaa authorization exec tacacs+

       service=ppp

       service=slip

       service=system      not used.

       service=raccess     Used for managing reverse telnet connections e.g.

                               user = jim {
                                   login = cleartext lab
                                   service = raccess {
                                       port#1 = clientname1/tty2
                                       port#2 = clientname2/tty5
                                   }
                               }

                           Requires IOS configuration

                               aaa authorization reverse-access tacacs+

       protocol=lcp        The lower layer of PPP, always brought up before IP, IPX, etc.  is brought up.

       protocol=ip         Used with service=ppp and service=slip to  indicate  which  protocol  layer  is  being
                           authorized.

       protocol=ipx        Used with service=ppp to indicate which protocol layer is being authorized.

       protocol=atalk      with service=ppp or service=arap

       protocol=vines      For vines over ppp.

       protocol=ccp        Authorization  of  CCP.   Compression  Control Protocol). No other AV-pairs associated
                           with this.

       protocol=cdp        Authorization of CDP (Cisco Discovery Protocol). No  other  av-pairs  associated  with
                           this.

       protocol=multilink  Authorization of multilink PPP.

       protocol=unknown    For undefined/unsupported conditions. Should not occur under normal circumstances.

       Incomplete  list  of  Cisco  AV  pairs.   Other  vendors may provide additional AV pairs specific to their
       products.

       acl    For EXEC authorization this contains an access-class number (acl=2) which is applied  to  the  line
              (tty) as the output access class.  The specified access-list must be predefined.

              ARAP, EXEC.

       addr   The  IP  address  the remote host should be assigned when a slip or PPP/IP connection is made.  For
              example: addr=1.2.3.4

              SLIP, PPP/IP.

       autocmd
              During exec startup, this specifies an autocommand, like the autocommand  option  to  the  username
              configuration command.  For example: autocmd="telnet foo.com"

              EXEC.

       callback-line
              The  number  of  a  TTY line to use for the callback.  Used with service=arap, slip, ppp, or shell.
              Does not work for ISDN.

       callback-rotary
              The number of a rotary group (0 through 100) to use for  the  callback.   Used  with  service=arap,
              slip, ppp, and shell.  Does not work for ISDN.

       cmd    If the value of cmd is NULL (cmd=), then this is an authorization request for starting an exec.

              If  cmd  is non-null, this is a command authorization request.  It contains the name of the command
              being authorized.  For example: cmd=telnet

              EXEC.

       cmd-arg
              During command authorization, the name of the command is given by an accompanying "cmd="  AV  pair,
              and each command argument is represented by a cmd-arg AV pair e.g. cmd-arg=archie.sura.net

              NOTE:  'cmd-arg'  should never appear in a configuration file.  It is used internally by the daemon
              to construct a string which is then matched against the regular expressions which appear in  a  cmd
              clause in the configuration file.

              EXEC.

       dns-servers
              Identifies  a  primary  or  backup DNS server that can be requested by Microsoft PPP clients during
              IPCP negotiation.  Used with service=ppp and protocol=ip.

       gw-password
              Specifies the  password  for  the  home  gateway  during  L2F  tunnel  authentication.   Used  with
              service=ppp and protocol=vpdn.

       idletime
              Sets a value, in minutes, after which an IDLE session will be terminated.  Does NOT work for PPP.

              EXEC, 11.1 onward.

       inacl  This  AV  pair contains an IP or IPX input access list number for slip or PPP (inacl=2). The access
              list itself must be pre-configured on the Cisco box. Per-user access lists do not  work  with  ISDN
              interfaces  unless  you  also configure a virtual interface. After 11.2(5.1)F, you can also use the
              name of a predefined named access list, instead of a number, for the value of this attribute.

              Note: For IPX, inacl is only valid after 11.2(4)F.

              PPP/IP/IPX.

       inacl#<n>
              This AV pair contains the definition of an input access list to be  installed  and  applied  to  an
              interface for the duration of the current connection, e.g.

                  inacl#1="permit ip any any precedence immediate"
                  inacl#2="deny igrp 0.0.1.2 255.255.0.0 any"

              Attributes  are  sorted  numerically  before they are applied.  For IP, standard OR extended access
              list syntax may be used, but it is an error to mix the two within a given access-list.

              For IPX, only extended access list syntax may be used.

              PPP/IP/PPP/IPX, 11.2(4)F.

       interface-config
              Specifies user-specific  AAA  interface  configuration  information  with  Virtual  Profiles.   The
              information that follows the equal sign (=) can be any Cisco IOS interface configuration command.

       ip-address
              List of possible IP addresses, separated by spaces, that can be used for the end-point of a tunnel.
              Used with service=ppp and protocol=vpdn.

       link-compression
              Defines whether to turn on or turn off Stac compression over a PPP link.  Valid values are:

                   0    None
                   1    Stac
                   2    Stac Draft-9
                   3    MS-Stac

       load-threshold
              This AV pair sets the load threshold at which an additional multilink link is added to  the  bundle
              (if load goes above) or deleted (if load goes below).

                  service=ppp protocol=multilink {
                      load-threshold=<n>
                  }

              The range of <n> is [1-255].

              PPP/multilink - Multilink parameter, 11.3.

       max-links
              This AV pair restricts the number of multilink bundle links that a user can have.

                  service=ppp protocol=multilink {
                      max-links=<n>
                  }

              The range of <n> is [1-255].

              PPP/multilink, 11.3.

       nas-password
              Specifies  the  password  for  the NAS during L2F tunnel authentication.  Used with service=ppp and
              protocol=vpdn.

       nocallback-verify
              Indicates that no callback verification is required. The only valid value for this parameter is the
              digit one,  i.e.  nocallback-verify=1.  Not valid for ISDN.  ARAP/EXEC, 11.1 onward.

       noescape
              During  exec  startup,  this  specifies  "noescape",  like  the  noescape  option  to  the username
              configuration command.  Can have  as  its  value  the  string  "true"  or  "false".   For  example:
              noescape=true

              EXEC.

       nohangup
              During  exec  startup,  this  specifies  "nohangup",  like  the  nohangup  option  to  the username
              configuration command.  Can have  as  its  value  the  string  "true"  or  "false".   For  example:
              nohangup=true

              EXEC.

       old-prompts
              Allows  the prompts in TACACS+ to appear identical to those of earlier systems (TACACS and Extended
              TACACS).  This allows the upgrade from TACACS or Extended TACACS to TACACS+ to  be  transparent  to
              users.

       outacl This  AV  pair  contains  an  IP  or  IPX  output  access  list  number for SLIP. PPP/IP or PPP/IPX
              connections (outacl=4). The access list itself must be pre-configured.  Per-user  access  lists  do
              not  work with ISDN interfaces unless you also configure a virtual interface.  PPP/IPX is supported
              in 11.1 onward only. After 11.2(5.1)F, you can also use the name of a predefined named access list,
              as well as a number, for the value of this attribute.

              PPP/IP, PPP/IPX.

       outacl#<n>
              This  AV pair contains an output access list definition to be installed and applied to an interface
              for the duration of the current connection.

                  outacl#1="permit ip any any precedence immediate"
                  outacl#2="deny igrp 0.0.9.10 255.255.0.0 any"

              Attributes are sorted numerically before they are applied.  For IP,  standard  OR  extended  access
              list syntax may be used, but it is an error to mix the two within a given access-list.

              For IPX, only extended access list syntax may be used.

              PPP/IP/PPP/IPX, 11.2(4)F.

       pool-def#
              Defines IP address pools on the NAS.  Used with service=ppp and protocol=ip.

       pool-timeout
              In  conjunction  with  pool-def,  defines  IP  address  pools  on  the  NAS.   During  IPCP address
              negotiation, if an IP pool name is specified for a user (see the addr-pool attribute), a  check  is
              made that the named pool is defined on the NAS.  If it is, the pool is consulted for an IP address.

       ppp-vj-slot-compression
              Instructs  the  Cisco  router not to use slot compression when sending VJ-compressed packets over a
              PPP link.

       priv-lvl
              Specifies the current privilege level for command authorizations, a number from zero  to  15.   For
              example: priv_lvl=5.

              Note: in 10.3 this attribute was priv_lvl, i.e.  it contained an underscore instead of a hyphen.

              EXEC.

       route  This  AV  pair specifies a temporary static route to be applied, which expunged once the connection
              terminates.  The daemon side declaration is:

                  service=ppp protocol=ip {
                      route="<dst_addr> <mask> [ <gateway> ]"
                  }

              <dst_address>, <mask>, and <gateway> are <IP address>'s.  If the gateway  is  omitted,  the  peer's
              address is assumed.

              PPP/IP/SLIP, 11.1 onward.

       route#<n>
              Same  as  the  "route"  attribute,  except that these are valid for IPX as well as IP, and they are
              numbered, allowing multiple routes to be applied.  For example:

                  route#1="3.0.0.0 255.0.0.0 1.2.3.4"
                  route#2="4.0.0.0 255.0.0.0"

              or, for IPX,

                  route#1="4C000000 ff000000 30.12.3.4"
                  route#2="5C000000 ff000000 30.12.3.5"

              PPP/IP/IPX, 11.2(4)F.

       routing
              Equivalent to the /routing flag in slip and ppp commands. Can have as its value the  string  "true"
              or "false".

              SLIP/PPP/IP.

       rte-ftr-in#
              Specifies  an  input  access  list definition to be installed and applied to routing updates on the
              current interface for the duration of the current connection.  Used with service=ppp protocol=ip or
              protocol=ipx.

       rte-ftr-out#
              Output version of rte-ftr-in#.

       sap#<n>
              This  AV pair specifies static SAPs (Service Advertising Protocol) to be installed for the duration
              of a connection.  For example:

                  sap#1="4 CE1-LAB 1234.0000.0000.0001 451 4"
                  sap#2="5 CE3-LAB 2345.0000.0000.0001 452 5"

              The syntax of static saps is the same as that used  by  the  IOS  "ipx  sap"  command.   Used  with
              service=ppp protocol=ipx.

              PPP/IPX, 11.2(4)F.

       sap-fltr-in#<n>
              This  AV  pair  specifies an input SAP filter access list definition to be installed and applied to
              the current interface, for the duration of the current connection.

              Only Cisco extended access list syntax is legal (ipx input-sap-filter <number>).  For example:

                  sap-fltr-in#1="deny 6C01.0000.0000.0001"
                  sap-fltr-in#2="permit -1"

              Attributes are sorted numerically before being applied.  Used with service=ppp protocol=ipx.

              PPP/IPX, 11.2(4)F.

       sap-fltr-out#<n>
              This AV pair specifies an output sap filter access list definition to be installed and  applied  on
              the current interface, for the duration of the current connection.

              Only Cisco extended access list syntax is legal (ipx output-sap-filter <number>), e.g

                  sap-fltr-out#1="deny 6C01.0000.0000.0001"
                  sap-fltr-out#2="permit -1"

              Attributes are sorted numerically before being applied.  Used with service=ppp protocol=ipx.

              PPP/IPX, 11.2(4)F.

       source-ip
              This specifies a single ip address that will be used as the source of all VPDN packets generated as
              part of the VPDN tunnel (see the equivalent source-ip keyword in the IOS vpdn outgoing command).

              PPP/VPDN, now deprecated, only existed in releases 11.2(1.4) thru 11.2(4.0.2).

       timeout
              Sets the time until an ARAP or exec session disconnects unconditionally (in minutes).  For example:
              timeout=60

              ARAP/EXEC, 11.0 onward.

       tunnel-id
              This  AV  pair  specifies  the username that will be used to authenticate the tunnel over which the
              individual user MID will be projected.  This is analogous to the "NAS name" in the "vpdn  outgoing"
              command.

              PPP/VPDN, 11.2 onward.

       zonelist
              An Appletalk zonelist for arap (ARAP) equivalent to the line configuration command "arap zonelist".
              For example: zonelist=5.

       AV pairs reserved for future use (this list may be out-dated):

           ppp-vj-slot-compression
           link-compression
           asyncmap
           x25-addresses (PPP/VPDN)
           frame-relay (PPP/VPDN)

       Note: this AV pair list is NOT complete and not all AV pairs  are  supported  by  all  vendors.   See  the
       vendor's  documentation.   When  a  client  (or  server)  receives  a  mandatory  AV pair that it does not
       understand, the authorization FAILS!

       Also see the tac_plus user guide.  Some of the callback, appletalk, IPX, VPDN, PPP  routing,  and  address
       pool related AV pairs found in the user guide have been omitted.

ACCOUNTING AV PAIRS
       bytes_in            The number of input bytes transferred during this connection.

       bytes_out           The number of output bytes transferred during this connection.

       cmd                 The command the user executed.

       data-rate           This AV pair has been renamed. See nas-rx-speed.

       disc-cause          Specifies  the reason a connection was taken off-line.  The Disconnect-Cause attribute
                           is sent in accounting stop records.  This attribute also causes  stop  records  to  be
                           generated   without   first   generating   start   records   if   disconnected  before
                           authentication.

                                1    User request
                                2    Lost carrier
                                3    Lost service
                                4    Idle timeout
                                5    Session timeout
                                6    Admin reset
                                7    Admin reboot
                                8    Port error
                                9    NAS error
                                10   NAS request
                                11   NAS reboot
                                12   Port unneeded
                                13   Port pre-empted
                                14   Port suspended
                                15   Service unavailable
                                16   Callback
                                17   User error
                                18   Host request

       disc-cause-ext      Extends the disc-cause attribute to support vendor-specific reasons that a  connection
                           was taken off-line.

                                1000 Session timed out. This value applies to all session types.
                                1002 Reason unknown.
                                1004 Failure to authenticate calling-party number.
                                1010 No carrier detected. This value applies to modem connections.
                                1011 Loss of carrier. This value applies to modem connections.
                                1012 Failure to detect modem result codes. This value applies to modem connections.
                                1020 User terminates a session. This value applies to EXEC sessions.
                                1021 Timeout waiting for user input. This value applies to all session types.
                                1022 Disconnect due to exiting Telnet session. This value applies to EXEC sessions.
                                1023 Could not switch to SLIP/PPP; the remote end has no IP address. This value applies to EXEC sessions.
                                1024 Disconnect due to exiting raw TCP. This value applies to EXEC sessions.
                                1025 Bad passwords. This value applies to EXEC sessions.
                                1026 Raw TCP disabled. This value applies to EXEC sessions.
                                1027 Control-C detected. This value applies to EXEC sessions.
                                1028 EXEC process destroyed. This value applies to EXEC sessions.
                                1040 PPP LCP negotiation timed out. This value applies to PPP sessions.
                                1041 PPP LCP negotiation failed.
                                1042 PPP PAP authentication failed.
                                1043 PPP CHAP authentication failed.
                                1044 PPP remote authentication failed.
                                1045 PPP received a Terminate Request from remote end.
                                1046 Upper layer requested that the session be closed.  This value applies to PPP sessions.
                                1101 Session failed for security reasons. This value applies to all session types.
                                1102 Session terminated due to callback. This value applies to all session types.
                                1120 Call refused because the detected protocol is disabled. This value applies to all session types.

       elapsed_time        The  elapsed time in seconds for the action. Useful when the device does not keep real
                           time.

       event               Information included in the accounting packet that describes a  state  change  in  the
                           router.  Events described are accounting starting and accounting stopping.

       mlp-links-max       Gives  the  count of links known to have been in a given multilink session at the time
                           the accounting record is generated.

       mlp-sess-id         Reports the identification number of the multilink bundle  when  the  session  closes.
                           This  attribute  applies  to  sessions  that  are  part  of  a multilink bundle.  This
                           attribute is sent in authentication-response packets.

       nas-rx-speed        Specifies the average number of bits per second over the course  of  the  connection's
                           lifetime.  This attribute is sent in accounting stop records.

       nas-tx-speed        Reports the transmit speed negotiated by the two modems.

       paks_in             The number of input packets transferred during this connection.

       paks_out            The number of output packets transferred during this connection.

       port                The port into which the user was logged.

       pre-bytes-in        Records  the  number  of input bytes before authentication.  This attribute is sent in
                           accounting stop records.

       pre-bytes-out       Records the number of output bytes before authentication.  This attribute is  sent  in
                           accounting stop records.

       pre-paks-in         Records  the  number of input packets before authentication. This attribute is sent in
                           accounting stop records.

       pre-paks-out        Records the number of output packets before authentication.  This attribute is sent in
                           accounting stop records as Pre-Output-Packets.

       pre-session-time    Specifies  the  length of time, in seconds, from when a call first connects to when it
                           completes authentication.

       priv_level          The privilege level associated with the action.

       protocol            The protocol associated with the action.

       reason              Information included in the accounting packet that describes the event that  caused  a
                           system  change.   Events  described  are system reload, system shutdown, or accounting
                           reconfiguration (turned on or off).

       service             The service the user used.

       start_time          The time, in seconds since 12:00 a.m. January 1, 1970, that the action  started.   The
                           clock must be configured to receive this information.

       stop_time           The  time,  in seconds since 12:00 a.m. January 1, 1970, that the action stopped.  The
                           clock must be configured to receive this information.

       task_id             Start and stop records for the same event must have matching (unique) task_id numbers.

       timezone            The time zone abbreviation for all timestamps included in this packet.

       xmit-rate           This AV pair has been renamed nas-tx-speed.

EXAMPLE CLIENT CONFIGURATION
       Example Cisco configuration for tacacs+:

           aaa new-model
           aaa authentication login default tacacs+ local
           aaa authentication enable default tacacs+ enable
           aaa authorization exec default tacacs+
           aaa accounting exec default start-stop tacacs+
           !
           username root privilege 15 password 0 <root's password>
           !
           tacacs-server key <your key here>
           tacacs-server host <ip_address>
           ip tacacs source-interface loopback0
           !
           enable secret 0 <enable password>

       Note that the aaa command syntax varies slightly between some versions of Cisco IOS  and  CatOS  (Catalyst
       OS) also varies.

       Example Juniper configuration for tacacs+:

           system {
               authentication-order [ password tacplus ];
               tacplus-server {
                   <ip_address> secret <your key here>;
                   <ip_address> {
                       secret <your key here>;
                       timeout 90;
                   }
               }
           }

       Both  of  these  examples  are  brief.   See  the  vendor's  documentation for a description of what these
       configuration commands specify and for additional commands and arguments.

       WARNING:  If not properly configured, it may not be possible to login to the device!

EXAMPLE TAC_PLUS CONFIGURATION
       key = "your key here"
       accounting file = /var/log/tac.acct
       # authentication users not appearing elsewhere via
       # the file /etc/passwd
       default authentication = file /etc/passwd

       acl = dial_only {
           # All access routers are in 192.168/16, but except for
           # 192.168.0.1 all backbone router are in 198.168.0/24.
           # deny access to the backbone routers.
           permit = ^192\.168\.0\.1$
           deny   = ^192\.168\.0\.
           permit = ^192\.168\.
       }

       group = no_backbone {
           # permit an exec to start and permit all commands and
           # services by default
           default service = permit

           service = exec {
               # When an exec is started, its connection access list
               # will be 4. "acl" is quoted because it is a keyword.
               # It also has an autocmd
               "acl" = 4
               autocmd = "telnet duffhost"
           }

           # group will only be allowed to login on NASes
           acl = dial_only
       }
       group = admin {
           # group members who don't have their own login password will be
           # looked up in /etc/passwd
           login = file /etc/passwd

           # group members who have no expiry date set will use this one
           expires = "Jan 1 1997"

           # deny access to backbone routers
           acl = dial_only
       }

       user = DEFAULT {
           service = ppp protocol = ip {
               addr-pool=foobar
           }
       }
       user = homer {
           default service = permit

           member = no_backbone
       }
       user = fred {
           login = des mEX027bHtzTlQ
           name = "Fred Flintstone"
           member = admin
           expires = "May 23 2005"
           arap = cleartext "Fred's arap secret"
           chap = cleartext "Fred's chap secret"

           service = exec {
               # When Fred starts an exec, his connection access
               # list is 5
               "acl" = 5

               # We require this autocmd to be done at startup
               autocmd = "telnet foo"
           }

           # All commands except show system are denied for Fred
           cmd = show {
               # Fred can run the following show command

               permit system
               deny .*
           }

           service = ppp protocol = ip {
               # Fred can run ip over ppp only if he uses one
               # of the following mandatory addresses. If he
               # supplies no address, the first one here will
               # be mandated

               addr=131.108.12.11
               addr=131.108.12.12
               addr=131.108.12.13
               addr=131.108.12.14

               # Fred's mandatory input access list number is 101
               inacl=101

               # We will suggest an output access list of 102, but the NAS may
               # choose to ignore or override it

               optional outacl=102
           }

           service = slip {
               # Fred can run slip. When he does, he will have to use
               # these mandatory access lists

               inacl=101
               outacl=102
           }
       }

       user = wilma {
           # Wilma has no password of her own, but she's a group member so
           # she'll use the group password if there is one. Same for her
           # password expiry date

           member = admin
       }

FILES
       /etc/tac_plus.conf            Configuration file.

       /var/log/tac_plus.acct        The default accounting file.

       /var/log/tac_plus.log         The default log file.

SEE ALSO
       gethostbyaddr(3), passwd(5), regexp(3), tac_plus(8), tac_pwd(8)

       Also see the tac_plus User Guide (user_guide) that came with the distribution.  The user  guide  does  not
       cover  all the modifications to the original Cisco version nor does this manual page cover everything that
       is in the user guide (callback configuration, for example).

AUTHOR
       The tac_plus (tacacs+) developer's kit is a product of Cisco Systems.  Made available at no cost and  with
       no  warranty  of  any  kind.   See  the  file COPYING and source files that came with the distribution for
       specifics.

HISTORY
       This manual page was adapted from code inspection and Cisco's tac_plus user guide.

BUGS
       This manual page is incomplete.

                                                  1 August 2013                                  tac_plus.conf(5)
```

