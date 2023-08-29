---
coding: utf-8

title: 'Discovery for BRSKI variations'
abbrev: BRSKI-discovery
docname: draft-ietf-anima-brski-discovery-00
stand_alone: true
ipr: trust200902
submissionType: IETF
area: Operations and Management
wg: ANIMA
kw: Internet-Draft
cat: std
consensus: true
date: 2023
pi:
  toc: 'yes'
  compact: 'yes'
  symrefs: 'yes'
  sortrefs: 'yes'
  iprnotified: 'no'
  strict: 'yes'
author:
- ins: T. Eckert
  name: Toerless Eckert
  role: editor
  org: Futurewei USA
  abbrev: Futurewei
  country: USA
  email: tte@cs.fau.de

contributor:
  name: Michael Richardson
  country: Canada
  phone: "+41 44 878 9200"
  email: mcr+ietf@sandelman.org

normative:
  CORE-LF:   RFC6690
  DNS-SD:    RFC6763
  GRASP:     RFC8990
  ACP:       RFC8994
  BRSKI:     RFC8995
  RFC8995:
  BRSKI-AE:  I-D.ietf-anima-brski-ae
  I-D.ietf-anima-brski-ae:
  BRSKI-PRM: I-D.ietf-anima-brski-prm
  I-D.ietf-anima-brski-prm:
  cBRSKI:    I-D.ietf-anima-constrained-voucher
  I-D.ietf-anima-constrained-voucher:
  cPROXY:    I-D.ietf-anima-constrained-join-proxy
  JWS-VOUCHER: I-D.ietf-anima-jws-voucher
  I-D.ietf-anima-jws-voucher:
  EST:       RFC7030
  RFC7030:
  RFC8368:
  CMP:       I-D.ietf-lamps-lightweight-cmp-profile
  I-D.ietf-lamps-lightweight-cmp-profile:

informative:
  COAP:      RFC7252
  SCEP:      RFC8894
  RFC8894:
  GRASP-DNSSD: I-D.eckert-anima-grasp-dnssd

--- abstract

This document specifies how BRSKI entities, such as registrars, proxies, pledges or others
that are acting as responders, can be discovered and selected by BRSKI entities acting as initiators.

--- middle

# Terminology {#terminology}

{::boilerplate bcp14-tagged}

This document relies on the terminology defined in {{BRSKI}}.  The following terms are described partly in addition.

Context:
: See Variation Context.

Initiator:
: A host that is using an IP transport protocol to initiate a connection or transaction to another host called the responder.

Initiator socket:
: A socket consisting of an initiators IP or IPv6 address, protocol and protocol port number from which it
  initiates connections or transactions to a responder (typically UDP or TCP).

Objective Name:
: See Service Name.

Resource Type:
: See Service Name.

Responder:
: A host that is using an IP transport protocol to respond to transaction or connection requests from an Initiator.

Responder socket:
: A socket consisting of a responders IP or IPv6 address, protocol and protocol port 
  number on which it responds to requests of the protocol (typically UDP or TCP).

Role:
: In the context of this document, a type of entity in a variation of BRSKI that can act as a responder and whose supported variations can be discovered. BRSKI roles relevant in this document include Join Registrar, Join Proxy and Pledge. The IANA registry defined by this document allows to specify variations for any roles. See also Variation Context.

Socket:
: The combination of am  IP or IPv6 address, an IP protocol that utilizes a port number (such as TCP or UDP) and a port number of that protocol.

Service Name:
: The name for (a subset of) the functionality/API provided by a discoverable responder socket. This term is inherited from {{DNS-SD}} but unless otherwise specified also used in this document to apply to any other discovery functionality/API. The terminology used by other mechanisms typically differs. For example, when {{GRASP}} is used to discover a responder socket for BRSKI, the Objective Name carries the equivalent to the service name. In {{CORE-LF}}, the Resource Type (rt=) carries the equivalent of the service name.

Type:
: See Variation Type.

Variation: 
: A combination one one variation choice each for every variation type applicable to the variation context of one discoverable BRSKI communications.
  For example, in the context of BRSKI, a variation is one choice for "mode", one choice for "enroll" and once choice for "vformat".

Variation Context:
: A set of Services for whom the same set of variations applies

Variation Type: 
: The name for one aspect of a protocol for which two or more choices exist (or may exist in the future), and where the choice 
  can technically be combined orthogonal to other variation types. This document defined the BRSKI variation types "mode", "enroll" and "vformat".

Variation Type Choice: 
: The name for different values that a particular variation type may have.
  For example, this document does defines the choices "rrm" and "prm" for the BRSKI variation "mode". 

# Overview 

The mechanisms described in this document are intended to help solve the following challenges.

Signaling BRSKI variation for responder selection.

When an initiator such as a proxy or pledge uses a mechanism such as
{{DNS-SD}} to discover an instance of a role it intends to connect to, such
as a registrar, it may discover more than one such instance. In the presence
of variations of the BRSKI mechanisms that impact interoperability, performance
or security, not all discovered instances may support exactly what the initiator needs to achieve
interoperability and/or best performance, security or other metrics. In this case, the service
announcement mechanism needs to carry the necessary additional information beside the name that
indicates the service to aid the initiator in
selecting an instance that it can interoperate and achieve best performance with.

Easier use of additional discovery mechanisms.

In the presence of different discovery mechanisms, such as {{DNS-SD}}, {{GRASP}},
{{CORE-LF}} or others, the details of how to apply each of these mechanisms are usually
specified individually for each mechanism, easily resulting in inconsistencies. Deriving
as much as possible the details of discovery from a common specification and registries
can reduce such inconsistencies and easy introduction of additional discovery mechansisms. 

Generalization of principles related to discovery and operation of proxies.

Because of the unified approach to discovery of BRSKI Variations described in this document,
it also allows to use {{DNS-SD}} for document for {{cBRSKI}} and {{cPROXY}}, which may be
of interest in networks such as Thread, which use {{DNS-SD}}.

# Specification

## Abstracted BRSKI discovery and selection

In the abstract model of discovery used by this document and intended to apply to all described discoverymechanisms, an entity operating as an initiator of a transport
connection for a particular BRSKI protocol role, such as a pledge, discovers one or more responder sockets
(IP/IPv6-address, responder-port, IP-protocol) of entities acting as responders for the peer BRSKI role, such
as registrar. The initiator uses some discovery mechanism such as {{DNS-SD}}, {{GRASP}} or {{CORE-LF}}. In the
the initiator looks for a particular combination of a Service Name and an IP-protocol, and in return learns
about responder sockets from one or more responders that use this IP-protocol and serve the requested Service Name
type service across it. It also learns the BRSKI variation(s) supported on the socket. 

Service Name is the name of the protocol element used in {{DNS-SD}}, unless explicitly specified, it is used
as a placeholder for the equivalent protocol elements in other discovery mechanisms. In {{GRASP}}, it is called
objective-name, in {{CORE-LF}} it is called Resource Type.

Upon discovery of the available sockets, the initiator selects one, whose supported variation(s) best match
the expectations of the initiator, including performance, security or other praeferences. Selection may also
include attempting to establish a connection to the responder socket, and upon connection failure
to attempt connecting to the next best responder socket. This is for example necessary when discovery
information may not be updated in real-time, and the best responder has gone offline.

## Variation Contexts

A Variation Context is a set of (Discover Mechanism, Service Names, IP-protocols) across which this document
and the registry of variations defines a common set of variations. The initial registry defined in this
document defines two variation contexts.

BRSKI context:
: context for discovery of BRSKI registrar and proxy variations by proxies, pledges or agents
  (as defined in {{BRSKI-PRM}}) via the Service Names defined for {{DNS-SD}} and {{GRASP}} via
  TCP and hence (by default) TLS (version 1.2 or higher according to {{BRSKI}}).

cBRSKI context (constrained BRSKI):
: context for discovery of BRSKI registrar and proxy variations by proxies, pledges 
  via the Service Names defined for {{DNS-SD}}, {{GRASP}} and {{CORE-LF}} via UDP, and hence (by default) secure COAP.

Note that the Service Names for cBRSKI include the same {{DNS-SD}} Service Names as for the BRSKI context,
hence enabling the use of {{DNS-SD}} with cBRSKI.

This document does not define variations for different end-to-end ecnryption mechanisms, so
only the "(by default)" options exist at the time of writing this document. However, the mechanisms described here
can also be used to introduce backward incompatible new secure transport options. For example when responders start
to support only TLS 1.3 or higher in the presence of TLS 1.2 only initiators, then new variations can be added,
such that those initiators will not select those responders.

This document does not introduce variation contexts for discovery of other BRSKI roles, such as discovery
of pledges by agents (as defined in {{BRSKI-PRM}}), or discovery of MASA by registrars. However, the registry
introduced by this document is defined such that it can be extended by such additional contexts through future
documents.

## Variation Types and Choices

A Variation Type is a variation in one aspect of the BRSKI connection between initiator and responder that ideally
orthogonal from variations in other aspects of the BRSKI connection.

A Variation Type Choice is one alternative (aka: value) for its Variation Type.

This document, and the initial registry documenting the variation types introduces three variation types as follows:

mode:
: A variation in the basic sequence of URI endpoints communicated. This document introduces the choices of
  "rrm" to indicate the endpoints and sequence as defined in {{BRSKI}} and "prm" to indicate the nedpoints and sequence
  as defined in {{BRSKI-PRM}}. Note that registrars also act as responders in "prm". "rrm" was choosen because the
  more logical "pim" (pledge initiator mode) term was feared to cause confusion with other technologies that use that term.

vformat (voucher format):
: A variation in the encoding format of the voucher communicated between registrar and pledge. This document introduces
  the choices "cms" as defined in {{BRSKI}}, "cose" as defined in {{cBRSKI}} and "jose" as defined in {{JWS-VOUCHER}}.

enroll:
: A variation in the URI endpoints used for enrollment of the pledge with keying material (trust anchors and certificate (chain)).
  This document introduces the choices "est" as introduced by {{BRSKI}} (to indicate the {{EST}} protocol)
  and "cmp" to indicate the lightweigt CMP profile ({{CMP}}) introduced by {{BRSKI-AE}}. It also reserved the choice
  "scep" to indicate {{SCEP}}. This is only a reservation, because no specification for the use of {{SCEP}} with BRSKI exist.

## Variations

A Variation is the combination of one Choice each for every Variation Type applicable to the Variation Context.
In other words, a variation is a possible instance of BRSKI if supported by initiator and responder. In {{BRSKI}},
the default variation is "registrar responder mode" (rrm) and use of the "cms voucher format" (cms).

## BRSKI Variations Discovery Registry

The IANA "BRSKI Variations Registry" as specified by this document, see {{registry}} specifies the
defined parameters for discovery of BRSKI variations.

### BRSKI Variation Contexts table

This  table ({{fig-contexts}}, defines the BRSKI Variations Contexts.

The "Applicable Variation Types" lists the Variation Types from whose choices a Variation for this
context is formed. The "Service Name(s)" colum lists the discovery mechanisms and their Service Name(s)
that constitute the context.

### BRSKI Variation Type Choices table

This table ({{fig-choices}}) defines the Variations Type Choices.

The "Context" column lists the BRSKI Variation Context(s) to which this line applies. If it is empty, then the same
Context(s) apply as that of the last prior line with a non-empty Context column.

The "Variation Type" column lists the BRSKi Variation Type to which this line applies. If it is empty, then the
same Variation Type applies as that of the last prior line with a non-empty Variation Type column.
Variation Types MUST the listed in the order in which the Variation Types are listed in the Applicable Variation Types
column of the BRSKI Variation Contexts table.

The "Variation Type Choice" column defines a Variation Type Choice term within the Context(s) of the line.
To allow the most flexible encodings of variations, all Variation Types and Variation Type Choices MUST be unique strings (across all Variation Types).
This allows to encode Variation Type Choices in a discovery mechanism without indicating their Variation Type. Variation Types
and Variation Type Choices and MUST be strings from lowercase letters a-z and digits 0-9 and MUST start with a letter. The
maximum length of a Variation Type Choice is 12 characters.

The "Reference" column specifies the documents which describe the Variation Type Choice. Relevant specification
includes those that only specify the semantics without referring to the aspects of discovery and/or those
that specify only the Discovery aspects. Current RFCs for BRSKI variations preceeding this RFC typically
only specify the semantics, and this document adds the discovery aspects.

The "Dflt" Flag specifies a Variation Type Choice that is assumed to be the default Choice for the Context,
such as "rrm" for the BRSKI context. Such a Variation Type Choice is to be assumed to be supported in discovery
if discovery is performed without indication of any or an empty signalling element to carry the Variation or
Variation Choices. For example, {{BRSKI}} specifies the empty string "" as the objective-value in {{GRASP}}
discovery. Because "rrm", "est" and "cms" are default in the BRSKI context, this Discovery signalling
indicates the support for those Variation Type Choices.

The "Dflt*" Flag specifies a Variation Type Choice that is only default in a subset of Discovery options in a
context. The Note(s) column has then to explain which subset this is. Like for "Dflt", the signalling in
this subset of Discovery options can then forego indication of the "Dflt*" Variation Type Choice.

The "Rsvd" Flag specifies a Variation Type Choice for which no complete specification exist on how to use it
within BRSKI (or more specifically the context), but which is known to be of potential interest. "Rsvd"
Variation Type Choices MUST NOT be considered for the  Discoverable Variations table. They are documented
primarily to reserve the Variation Type Choice term. 

The Note(s) section expands the Variation Type Choice terms and provides additional beneficial specification
references beyond the "Reference" column.

### BRSKI Discoverable Variations table {#variation}

This table {{fig-variations}} enumerates the Discoverable Variations and categorizes them.

The "Context" column lists the BRSKI Variation Context(s) to which this line applies. If it is empty, then the same
Context(s) apply as that of the last prior line with a non-empty Context column.

The "Spec / Applicability" lists the document(s) that specify the variation, if the variation is
explicitly described. If the variation is not described explicitly, but rather a combination of
Variation Type Choices from more than one BRSKI related specification, then this column will
indicate "-" if by expert opinion it is assumed that this variation should work, or "NA", if
by expert opinion, this variation could not work. The "Explanations" column includes references
to the relevant documents and as necessary additional explanation.

The "Variation" colum lists the Variation Type Choices that form the Variation. The Variation Type Choices
MUST be listed in the order in which the Variation Types are listed in the Applicable Variation Types
column of the BRSKI Variation Contexts table. 

The "Variation String" column has the string term used to indicate the variation when using the
simple encoding of BRSKI Variation Discovery for GRASP as described in {{grasp}}. It is formed by
concatenating the Choices term from the Variation colum with the "-" character, excluding those
Choices terms (and "-" concatenator) which are Default for the Context. If this procedure ends
up with the empty string, then this is indicated as "" in the column.

The "Explanations" column explains the "Spec / Applicability" status of the Variation.

### Extending or modifying the registry

Unless otherwise specified below, extension or changes to the registry require standards action.

Additional Variation Type Choices and Variation Context discovery mechanism Service Names including
additional discovery mechanisms require (only) specification and expert review if they refer to non standard action
protocols and/or protocol variation aspects. For example, a specification how to use {{SCEP}} with BRSKI would
fall under this clause as it is an informational RFC.

Non standards action Variation Type Choices can not be Default(Dflt). They can only be Dflt* for non standards action
(sub)Contexts.

Reservation of additional Variation Type Choices requires (only) expert review.

Additional Contexts MUST be added at the end of the BRSKI Variation Contexts table.

Additional Variation Types MUST be added at the end of the Applicable Variation Types column of the
BRSKI Variation Contexts table and at the end of existing lines for the Context in the 
BRSKI Variation Type Choices. Additional Variation Types MUST be introduced with a Default (Dflt) 
Variation Type Choice. These rules ensures that the rule to create the Variation String for GRASP
(and as desired by othrer discovery mechanism), and it also enables to add new Variation Type and Choices
wthout changing pre-existing Variation Strings: Any Variations String implicitly include the Default Choice for
any future Variation Types.

When a new Variation Type is added, their Default Choice SHOULD be added to the Variation Column of existing
applicable lines in the BRSKI Discoverable Variations table. Variations that include new non-Default 
Variation Type Choices SHOULD be added at the end of the existing lines for the Context.

## BRSKI Join Proxies support for Variations

### Permissible Variations

Variations according to the terminology of this document are those that do not require changes to BRSKI join proxy operations,
but that can transparently pass across existing join proxies without changes to them - as long as they support the rules
outlined in this document.

Different choices for e.g.: pledge to registrar encryption mechanisms, voucher format (vformat), use of different URI endpoints or enrolment
protocol endpoints (mode) are all transparent to join proxies, and hence join proxies can not only support existing, well-defined
Choices of these Variation Types, but without changes to the proxies also future ones - and only those are permitted to become
Variation Type Choices.

Changes to the BRSKI mechanism that do require additional changes to join proxies are not considered Variations
according to this document and MUST NOT use the same discovery protocol signaling elements as those defined for variations
by this document. Instead, they SHOULD use different combinations of Service Name and Protocol (e.g.: TCP vs. UDP).

For example, the stateless join proxy mode defined by {{cPROXY}} is such a mechanism that requires explicit
join proxy support. Therefore, registrars sockets that support circuit proxy mode use the GRASP objective "AN_join_registrar",
and registrar sockets that support stateless join proxy mode use the GRASP objective "AN_join_registrar_rjp". This
enables join proxies to select the registrar and socket according to what the join proxy supports and prefers. By
not using the same signaling element(s) for variations, join proxies can support discovery of all variations
independent of their support for stateless join proxy operations.

### Join Proxy support for Variations {#proxy}

Join proxies supporting the mechanisms of this document MUST signal for each socket they announce to initiators via a discovery
mechanism the Variation(s) supported on the socket. These Variation(s) MUST all be supported by the registrar that the join
proxy then uses for the connection from the initiator (e.g.: pledge). Pledges SHOULD announce sockets to initiators so that
all Variations that are supported by registrars that the join proxy can interoperate with are also available to the initiators
connecting to the join proxy.

To meet these requirements, join proxies can employ different implementation option. In the most simple one, a join proxy
allocates a separate responder socket for every Variation for which it discovers one or more registrars supporting
this Variation. It then announces that socket with only that one Variation in the discovery mechanism, even if the Registrar(s) are all
announcing their socket with multiple Variations. When the join proxy operates in circuit mode, it can then
select one of the registrars supporting the variation for every new initiator connection based on policies
as specified by BRSKi specifications and/or discovery parameters, such as priority and weight when {{DNS-SD}} is used,
and redundant registrars include those parameters.

TBD: insert example of received Registrar annoncement and created proxy announcement ??

Join proxies MAY reduce the number of sockets announced to initiators by using a single socket for all Variations for
which they have the same set of registrar sockets supporting those Variations. This primarily helps to reduce the size
of the discovery messages to initiators and can save socket resources on the join proxy.

Join proxies MAY create multiple sockets in support of other discovery options, even for the same Variation(s).
For example, if {{DNS-SD}} is used by two registrars, both announcing the same priority but different weights, then 
the join proxy may create a separate socket for each of these registrars - and their variations, so that the join proxy can equally announce the same
priority and weight for both sockets to initiators. This allows to maintain the desired weights of use of registrars,
even when the join proxy operates in stateless mode, in which it can not select a separate registrar for every 
client initiating a connection.

### Co-location of Proxy and Registrar {#colo}

In networks using {{BRSKI}} and {{ACP}}, registrars must have a co-located
proxy, because pledges can only use single-hop discovery (DULL-GRASP) and will only discover
proxies, but not registrar. Such a co-located proxy does not constitute additional processing/code
on a registrar supporting circuit mode, it simply implies that the registrars BRSKI services(s) are
announced with a proxy Service Name, to support pledges, and the  registrar service name, to
support join proxies.

To ease consistency of deployment models in the face of different discovery mechanisms, Variations and
non-Variation enhancements to BRSKI, it is RECOMMENDED that all future options to BRSKI do always have
a Service Name for proxies and a separate Service Name in support of pledge or other initiators. Pledges
and other initiators SHOULD always only look for the proxy Service Name, and only Proxies should look
for a registrar Service Name. Registrars therefore SHOULD always include the proxy functionaliy according
to the prior paragraph. This only involves additional code on the registrar beyond the service announcement
in case the Registrar would otherwise not implement circuit mode.

## Variation encoding rules for discovery mechanisms

### DNS-SD

Currently defined Variation Type Choices are encoded as {{DNS-SD}} Keys with a value of 1 in the DNS-SD service instances TXT Record.
This is possible because all Variation Type Choices are required to be unique across all Variation Types. It also allows to shorten
the encoding from "key=1" to just "key" for every Variation Type Choice, so that the TXT-DATA encoding can be more compact.

If the TXT Record does not contain a Variation Type Choice for a particular applicable Variation Type, then this indicates
support for the Default Choice of this Variation Type in the context of the DNS-SD Service Name. For example, if the TXT
Record is "jose", then this indicates support for "rrm" and "est", if the Service Name is brski-registrar or brski-proxy and the
protocol is TCP (BRSKI Context), but also when the protocol is UDP (cBRSKI context), because "rrm" and "est" are defaults
in both contexts.

If multiple Variation Type Choices for the same Variation Type are indicated, then this implies
that either of these Variation Type Choices is supported in conjunction with any of the othrer
Variation Type Choices in the same TXT Record. For example, if the TXT Record is "prm" "rrm" "cms" "jose", then
this implies support for rrm-cms-est, rrm-jose-est, prm-cms-est and prm-jose-est. This example also shows
that if the default Variation Type Choice, such as "rrm" and another Choice of the same Variation Type ("prm") are to
be indicated as supported, then both need to be included in the TXT Record.

In {{DNS-SD}}, a responder does not only indicate a Service Name, but also its Service Instance Name. This specification
makes no recommendation for choosing the Instance portion of that name. Usually it is the same, or derived from some form
of system name. If the responder needs to indicate different sockets for differernt (set of) Variations, for example,
when operating as a proxy, according to {{proxy}}, then it needs to signal for each socket a separate Service Instance Name
with the appropriate port information in its SRV Record and the supported Variations for that socket in the TXT Record of that
Service Instance Name. In this case, it is RECOMMENDED that the Instance Name includes the Variation it supports,
such as in the format specified in {{variation}} and used in the Variation String column of the {{fig-variations}} table.

TBD: Add an example for DNS-SD.

### GRASP {#grasp}

To announce protocol variations with {{GRASP}}, the supported Variation is indicated in the 
objective-value field of the GRASP objective, using the method of forming the Variation string term
in {{variation}}, and listed in the Variation String column of the {{fig-variations}} table.

If more than one Variation is supported, then multiple objectives have to be announced, each with
a different objective-value, but the same location information if the different Variations are
supported across the same socket. Different sockets require different objective structures in GRASP anyhow.

Compared to DNS-SD, the choice of encoding for GRASP optimizes for minimum parsing effort, whereas
the DNS-SD encoding is optimized for most compact encoding given the limit for DNS-SD TXT records.

~~~~
[M_FLOOD, 12340815, h'fe800000000000000000000000000001', 180000,
    [["AN_Proxy", 4, 1, "",
     [O_IPv6_LOCATOR,
     h'fe800000000000000000000000000001', IPPROTO_TCP, 4443]
     ["AN_Proxy", 4, 1, "prm",
     [O_IPv6_LOCATOR,
     h'fe800000000000000000000000000001', IPPROTO_TCP, 4443]]
]
~~~~
{: #grasp-example-1 title='GRASP example for a BRSKI registrar supporting RRM and PRM'}

{{grasp-example-1}} is an example for a GRASP service announcement for "AN_Proxy" in support of BRSKI
with both "rrm" and "prm" supported on the same socket.

### CORE-LF

TBD

# IANA considerations

## BRSKI Variations Discovery Registry (section) {#registry}

This document requests a new section named "BRSKI Variations Discovery Parameters"
in the "Bootstrapping Remote Secure Key Infrastructures (BRSKI) Parameters"
registry (https://www.iana.org/assignments/brski-parameters/brski-parameters.xhtml).
Its initial content is as follows.

\[ RFC editor. Please remove the following sentence.
Note: This section contains three tables according to the specifications of this document.
If it is not possible to introduce more than one table per section, then we will modify the request
accordingly for thee sections, but given how the three tables are tighly linked, that would be unfortunate. ]

Registration Procedure(s):
  Standards action or expert review based on registration.  See ThisRFC.

Experts:
  TBD.

Reference:
  ThisRFC.

Notes:

Dflt flag:
: Indicates a Variation Type Choice that is assumed to be used if the service discover/selection mechanism does not indicate any variation.

Rsvd Flag:
: Indicates a Variation Type Choice that is reserved for use with the mechanism described in the Note(s) column, but for which no specification yet exists.

Spec / Applicability:
: A "-" indicates that the variation is considered to be feasible through existing specifications, but not explicitly mentioned in them.
  An "NA" indicates that the combination is assumed to be not working with the currently available specifications.

| Context         | Applicable Variation Types | Service Name(s)|
|:----------------|:---------------------------|:--------------|
| BRSKI           | mode vformat enroll        | GRASP objectives "AN_join_registrar" / "AN_Proxy" with IPPROTO_TCP |
|                 |                            |  "brski-registrar" / "brski-proxy" in DNS-SD with TCP              |
| cBRSKI          | mode vformat enroll        | GRASP objectives "AN_join_registrar" / "AN_join_registrar_rjp" / "AN_Proxy" with IPPROTO_UDP |
|                 |                            | "brski-registrar" / "brski-proxy" in DNS-SD with UDP |
|                 |                            | rt=brski.* with CORE-LF(RFC6690) |
{: #fig-contexts title="BRSKI Variation Contexts"}

| Context         | Variation<br>Type | Variation <br>Type Choice | Reference | Flags | Note(s)                                                |
|:----------------|:--------|:----------|:-----------------------|:-----|:---------------------------------------------------------------------|
| BRSKI, cBRSKI   | mode    | rrm       | {{RFC8995}}<br>ThisRFC   | Dflt | Registrar Responder Mode <br> the mode specified in {{RFC8995}}      |
|                 |         | prm       | ThisRFC  <br>          |      | Pledge Responder Mode    <br> {{I-D.ietf-anima-brski-prm}}           |
| BRSKI           | vformat | cms       | {{RFC8368}}<br>ThisRFC   | Dflt | CMS-signed JSON Voucher  <br>                                        |
|                 |         | cose      | ThisRFC<br>            |      | CBOR with COSE signature <br>                                        |
| cBRSKI          |         | cose      | ThisRFC<br>            | Dflt | CBOR with COSE signature <br> {{I-D.ietf-anima-constrained-voucher}} |
|                 |         | cms       | {{RFC8368}}<br>ThisRFC   |      | CMS-signed JSON Voucher  <br>                                        |
| BRSKI, cBRSKI   |         | jose      | ThisRFC<br>            |Dflt* | JOSE-signed JSON, Default when prm is used<br> {{I-D.ietf-anima-jws-voucher}}, {{I-D.ietf-anima-brski-ae}} |
| BRSKI, cBRSKI   | enroll  | est       | {{RFC8995}}<br>{{RFC7030}} | Dflt | Enroll via EST           <br> as specified in {{RFC8995}}               |
|                 |         | cmp       | ThisRFC                |      | Lightweight CMP Profile  <br> {I-D.ietf-anima-brski-ae}}, {{I-D.ietf-lamps-lightweight-cmp-profile}} |
|                 |         | scep      | ThisRFC                | Rsvd | {{RFC8894}}                                                          |
{: #fig-choices title="BRSKI Variation Type Choices"}

| Context | Spec / Applicability        | Variation String| Variation | Explanations|
|:--------|:----------------------------|:---------------------|:----------|:------------|
| BRSKI   |[RFC8995]                    | ""            | rrm cms  est |                 |
|         |{{I-D.ietf-anima-brski-ae}}  | cmp           | rrm cms  cmp |                 |
|         |{{I-D.ietf-anima-brski-prm}} | prm           | prm jose est |                 |
|         |                             |               |              |                 |
|         | -                           | jose          | rrm jose est |possible variation of {{RFC8995}} with voucher according to {{I-D.ietf-anima-jws-voucher}} |
|         | -                           | jose-cmp      | rrm jose cmp |possible variation of {{RFC8995}} with voucher according to {{I-D.ietf-anima-jws-voucher}} and enrollment according to {{I-D.ietf-lamps-lightweight-cmp-profile}} |
|         | -                           | cose          | rrm cose est |possible variation of {{RFC8995}} with voucher according to {{I-D.ietf-anima-constrained-voucher}} |
|         | -                           | cose-cmp      | rrm cose cmp |possible variation of {{RFC8995}} with voucher according to {{I-D.ietf-anima-constrained-voucher}} and enrollment according to {{I-D.ietf-lamps-lightweight-cmp-profile}} |
|         | -                           | prm-cmp       | prm jose cmp |possible variation of {{I-D.ietf-anima-brski-prm}} and {{I-D.ietf-anima-brski-ae}} |
|         | -                           | prm-cose      | prm cose est |possible variation of {{I-D.ietf-anima-brski-prm}} and {{I-D.ietf-anima-constrained-voucher}} |
|         | -                           | prm-cose-cmp  | prm cose cmp |possible variation of {{I-D.ietf-anima-brski-prm}}, {{I-D.ietf-anima-constrained-voucher}} and {{I-D.ietf-anima-brski-ae}} |
|         |                             |               |              |                     |
| cBRSKI  |{{I-D.ietf-anima-constrained-voucher}} | ""  | rrm cose est |                     |
|         |                             |               |              |                     |
|         | -                           |               |              |TBD: all the possible variations as for BRSKI ??? |
{: #fig-variations ="BRSKI Discoverable Variations"}

## Service Names Registry

IANA is asked to modify and amend the "Service Name and Transport Protocol Port Number Registry" registry (https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.txt) as follows:

brski-proxy and brski-registar are to be added as Service Names for the "udp" protocol using ThisRFC as the reference.

The registrartions for brski-proxy and brski-registar for the "tcp" protocol are to be updated to also include ThisRFC as their reference.

The Defined TXT keys column for brski-proxy and brski-registar for both "tcp" and "udp" protocols are to state the following text:

See ThisRFC and the "BRSKI Variation Type Choices" table in the "Bootstrapping Remote Secure Key Infrastructures (BRSKI) Parameters" registry.

TBD: This request likely does not include all the necessary formatting.

## BRSKI Well-Known URIs fixes (opportunistic)

The following change requests to "https://www.iana.org/assignments/brski-parameters/brski-parameters.xhtml#brski-well-known-uris" are cosmetic in nature and are included in this document solely because support for Endpoint URIs is implied by the mechanisms specified in this document and the existing registry has these cosmetic issues.

1. IANA is asked to change the name of the first column of the table from "URI" to "URI Suffix". This is in alignment with other table columns with the same syntax/semantic, such as "https://www.iana.org/assignments/well-known-uris/well-known-uris.xhtml".

2. IANA is asked to change the Reference from {{BRSKI}} to {{BRSKI, Section 8.3.1}}.

3. IANA is asked to include the following "Note" text: The following table contains the assigned BRSKI protocol Endpoint URI suffixes under "/.well-known/brski"." - This note is added to introduce the term "Endpoint" into the registry table as that is the term commonly used (instead of URI) in several of the memos for which this discovery document was written. It is meant to help readers map the registry to the terminoloy used in those documents.

# Security Considerations {#sec-consider}

TBD.

# Acknowledgments

TBD.

# Changelog

\[RFC Editor: please remove this section.]

Individual version 00:

Initial version.

--- back

# Discovery for constrained BRSKI

This appendix section is intended to describe the current issues with {{cBRSKI}} and {{cPROXY}} as of 08/2023, which
make both drafts incompatible with this document. It will be removed if/when those issues will be fixed.

## Current constrained text for GRASP

The following is the current encodings from {{cBRSKI}}.

*  The transport-proto is IPPROTO_UDP

*  the objective is AN_join_registrar, identical to {{BRSKI}}.

*  the objective name is "BRSKI_RJP".

Here is an example M_FLOOD announcing the Registrar on example port 5685, which is a port number chosen by the Registrar.

~~~~
[M_FLOOD, 51804231, h'fda379a6f6ee00000200000064000001', 180000,
[["AN_join_registrar", 4, 255, "BRSKI_RJP"],
[O_IPv6_LOCATOR,
h'fda379a6f6ee00000200000064000001', IPPROTO_UDP, 5685]]]
~~~~
{: #cbrski-fig5 title="cBRSKI Fig 5: Example of Registrar announcement message" artwork-align="left"}

Most Registrars will announce both a JPY-stateless and stateful ports, and may also announce an HTTPS/TLS service:

~~~~
[M_FLOOD, 51840231, h'fda379a6f6ee00000200000064000001', 180000,
[["AN_join_registrar", 4, 255, ""],
 [O_IPv6_LOCATOR,
  h'fda379a6f6ee00000200000064000001', IPPROTO_TCP, 8443],
 ["AN_join_registrar", 4, 255, "BRSKI_JP"],
 [O_IPv6_LOCATOR,
  h'fda379a6f6ee00000200000064000001', IPPROTO_UDP, 5684],
 ["AN_join_registrar", 4, 255, "BRSKI_RJP"],
 [O_IPv6_LOCATOR,
  h'fda379a6f6ee00000200000064000001', IPPROTO_UDP, 5685]]]
~~~~
{: #cbrski-fig6 title='cBRSKI Fig 6: Example of Registrar announcing two services" artwork-align="left"}

The following is the current text from {{cPROXY}}.

* The transport-proto is IPPROTO_UDP
* the objective is AN\_join\_registrar, identical to {{BRSKI}}.
* the objective name is "BRSKI_RJP".

Here is an example M\_FLOOD announcing the Registrar on example port 5685, which is a port number chosen by the Registrar.

~~~
   [M_FLOOD, 51804231, h'fda379a6f6ee00000200000064000001', 180000,
   [["AN_join_registrar", 4, 255, "BRSKI_RJP"],
    [O_IPv6_LOCATOR,
     h'fda379a6f6ee00000200000064000001', IPPROTO_UDP, 5685]]]
~~~
{: #cproxy-rjp title='Example of Registrar announcement message' align="left"}

Most Registrars will announce both a JPY-stateless and stateful ports, and may also announce an HTTPS/TLS service:

~~~
   [M_FLOOD, 51840231, h'fda379a6f6ee00000200000064000001', 180000,
   [["AN_join_registrar", 4, 255, ""],
    [O_IPv6_LOCATOR,
     h'fda379a6f6ee00000200000064000001', IPPROTO_TCP, 8443],
    ["AN_join_registrar", 4, 255, "BRSKI_JP"],
    [O_IPv6_LOCATOR,
     h'fda379a6f6ee00000200000064000001', IPPROTO_UDP, 5684],
    ["AN_join_registrar", 4, 255, "BRSKI_RJP"],
    [O_IPv6_LOCATOR,
     h'fda379a6f6ee00000200000064000001', IPPROTO_UDP, 5685]]]
~~~
{: #cproxy-rjp-example title='Example of Registrar announcing two services' align="left"}

### Issues and proposed change

One goal of this document is to define variations such that proxies can deal with existing
and future variations. This only works for variations for which proxies would need to perform
specific processing other than passing on data between pledge and registrar.

Changes in protocol that require specific new behavior of proxies must therefore not be
variations signalled via the objective-value field of GRASP objectives.

In result, this document recommends the following changes to the encoding for {{cBRSKI}} and {{cPROXY}}.

~~~~
[M_FLOOD, 51840231, h'fda379a6f6ee00000200000064000001', 180000,
[["AN_join_registrar", 4, 255, ""],
 [O_IPv6_LOCATOR,
  h'fda379a6f6ee00000200000064000001', IPPROTO_TCP, 8443],
 ["AN_join_registrar", 4, 255, ""],
 [O_IPv6_LOCATOR,
  h'fda379a6f6ee00000200000064000001', IPPROTO_UDP, 5684],
 ["AN_join_registrar_rjp", 4, 255, ""],
 [O_IPv6_LOCATOR,
  h'fda379a6f6ee00000200000064000001', IPPROTO_UDP, 5685]]]
~~~~
{: #new-example title='Proposed Encoding of registrar announcements' align="left"}

In summary:

* Circuit proxy operation is indicted with objective-name "AN_join_registrar" and IPPROTO_UDP.
  The default for AN_join_registrar/UDP is the use of COAPs and CBOR encoded voucher. For this
  default, the objective-value is "".

* Stateless JRP proxy operations is indicated with objective-name "AN_join_registrar_rjp" and IPPROTO_UDP.
  The default for AN_join_registrar/UDP is the use of COAPs and CBOR encoded voucher. For this
  default, the objective-value is "".

