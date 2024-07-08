---
coding: utf-8

title: 'Discovery for BRSKI variations'
abbrev: BRSKI-discovery
docname: draft-ietf-anima-brski-discovery-03
stand_alone: true
ipr: trust200902
submissionType: IETF
area: Operations and Management
wg: ANIMA
kw: Internet-Draft
cat: std
consensus: true
date: 2024
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
- ins: E. Dijk
  name: Esko Dijk
  org: IoTconsultancy.nl
  email: esko.dijk@iotconsultancy.nl

contributor:
- name: Thomas Werner
  country: Germany
  org: Siemens AG
  email: thomas-werner@siemens.com
  uri: https://www.siemens.com/
- name: Steffen Fries
  country: Germany
  org: Siemens AG
  email: steffen.fries@siemens.com
  uri: https://www.siemens.com/
- name: Hendrik Brockhaus
  country: Germany
  org: Siemens AG
  email: hendrik.brockhaus@siemens.com
  uri: https://www.siemens.com/
- name: Michael Richardson
  country: Canada
  phone: "+41 44 878 9200"
  email: mcr+ietf@sandelman.org
- ins: D. von&nbsp;Oheimb
  name: David von&nbsp;Oheimb
  org: Siemens AG
  abbrev: Siemens
  street: Otto-Hahn-Ring 6
  city: Munich
  code: '81739'
  country: Germany
  email: david.von.oheimb@siemens.com
  uri: https://www.siemens.com/

normative:
  RFC3986:
  RFC5280:
  RFC6690:
  RFC6762:
  RFC6763:
  RFC7390:
  RFC8990:
  RFC8994:
  RFC8995:
  I-D.ietf-anima-brski-ae:
  I-D.ietf-anima-brski-prm:
  I-D.ietf-anima-constrained-voucher:
  I-D.ietf-anima-constrained-join-proxy:
  I-D.ietf-anima-jws-voucher:
  RFC7030:
  RFC8368:
  I-D.ietf-lamps-lightweight-cmp-profile:
  I-D.ietf-dnssd-srp:
  RFC9148:
  RFC9176:

informative:
  RFC5988:
  RFC7252:
  RFC8894:
  I-D.eckert-anima-grasp-dnssd:

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

{: #ACP}ACP:
: "An Autonomic Control Plane", {{RFC8994}}.

{: #BRSKI}BRSKI:
: "Bootstrapping Remote Secure Key Infrastructure", {{RFC8995}}.

{: #BRSKI-AE}BRSKI-AE:
: "Alternative Enrollment Protocols in {{BRSKI}}", {{I-D.ietf-anima-brski-ae}}.

{: #BRSKI-PRM}BRSKI-PRM:
: "{{BRSKI}} with Pledge in Responder Mode", {{I-D.ietf-anima-brski-prm}}.

{: #cBRSKI}cBRSKI:
: "Constrained Bootstrapping Remote Secure Key Infrastructure ({{BRSKI}})", {{I-D.ietf-anima-constrained-voucher}}.

{: #COAP}COAP:
: "The Constrained Application Protocol (CoAP)", {{RFC7252}}.

{: #CORE-LF}CORE-LF:
: "Constrained RESTful Environments (CoRE) Link Format", {{RFC6690}}.

{: #cPROXY}cPROXY:
: "Constrained Join Proxy for Bootstrapping Protocols", {{I-D.ietf-anima-constrained-join-proxy}}.

{: #DNS-SD}DNS-SD:
: "DNS-Based Service Discovery", {{RFC6763}}.

{: #EST}EST:
: "Enrollment over Secure Transport", {{RFC7030}}.

{: #GRASP}GRASP:
: "GeneRic Autonomic Signaling Protocol", {{RFC8990}}.

{: #GRASP-DNSSD}GRASP-DNSSD:
: "DNS-SD Compatible Service Discovery in GeneRic Autonomic Signaling Protocol (GRASP)", {{I-D.eckert-anima-grasp-dnssd}}.

{: #JWS-VOUCHER}JWS-VOUCHER:
: "JWS signed Voucher Artifacts for Bootstrapping Protocols", {{I-D.ietf-anima-jws-voucher}}.

{: #lwCMP}lwCMP:
: "Lightweight Certificate Management Protocol (CMP) Profile", {{I-D.ietf-lamps-lightweight-cmp-profile}}.

{: #mDNS}mDNS:
: "multicast DNS", {{RFC6762}}.

{: #SCEP}SCEP:
: "Simple Certificate Enrolment Protocol", {{RFC8894}}.

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
selecting an instance that it can inter operate and achieve best performance with.

Easier use of additional discovery mechanisms.

In the presence of different discovery mechanisms, such as {{DNS-SD}}, {{GRASP}},
{{CORE-LF}} or others, the details of how to apply each of these mechanisms are usually
specified individually for each mechanism, easily resulting in inconsistencies. Deriving
as much as possible the details of discovery from a common specification and registries
can reduce such inconsistencies and easy introduction of additional discovery mechanisms.

Generalization of principles related to discovery and operation of proxies.

Because of the unified approach to discovery of BRSKI Variations described in this document,
it also allows to use {{DNS-SD}} for document for {{cBRSKI}} and {{cPROXY}}, which may be
of interest in networks such as Thread, which use {{DNS-SD}}.

# Specification

## Abstracted BRSKI discovery and selection

In the abstract model of discovery used by this document and intended to apply to all described discovery mechanisms, an entity operating as an initiator of a transport
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
the expectations of the initiator, including performance, security or other preferences. Selection may also
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

This document does not define variations for different end-to-end encryption mechanisms, so
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
  "rrm" to indicate the endpoints and sequence as defined in {{BRSKI}} and "prm" to indicate the endpoints and sequence
  as defined in {{BRSKI-PRM}}. Note that registrars also act as responders in "prm". "rrm" was chosen because the
  more logical "pim" (pledge initiator mode) term was feared to cause confusion with other technologies that use that term.

vformat (voucher format):
: A variation in the encoding format of the voucher communicated between registrar and pledge. This document introduces
  the choices "cms" as defined in {{BRSKI}}, "cose" as defined in {{cBRSKI}} and "jose" as defined in {{JWS-VOUCHER}}.

enroll:
: A variation in the URI endpoints used for enrollment of the pledge with keying material (trust anchors and certificate (chain)). This document introduces the following :choices

   * "est" as introduced by {{BRSKI}} to indicate the {{EST}} protocol, which is default
   * "cmp" to indicate the CMP protocol according to the Lightweight CMP profile ({{lwCMP}}). The respective adaptations to BRSKI have been introduced by {{BRSKI-AE}}.
   * "scep" to indicate {{SCEP}}. This is only a reservation, because no specification for the use of {{SCEP}} with BRSKI exists.

## Variations

A Variation is the combination of one Choice each for every Variation Type applicable to the Variation Context.
In other words, a variation is a possible instance of BRSKI if supported by initiator and responder. In {{BRSKI}},
the default variation is "registrar responder mode" (rrm) and use of the "cms voucher format" (cms).

## BRSKI Variations Discovery Registry

The IANA "BRSKI Variations Registry" as specified by this document, see {{registry}} specifies the
defined parameters for discovery of BRSKI variations.

### BRSKI Variation Contexts table

This table, {{fig-contexts}}, defines the BRSKI Variations Contexts.

The "Applicable Variation Types" lists the Variation Types from whose choices a Variation for this
context is formed. The "Service Name(s)" column lists the discovery mechanisms and their Service Name(s)
that constitute the context.

### BRSKI Variation Type Choices table

This table, {{fig-choices}}, defines the Variations Type Choices.

The "Context" column lists the BRSKI Variation Context(s) to which this line applies. If it is empty, then the same
Context(s) apply as that of the last prior line with a non-empty Context column.

The "Variation Type" column lists the BRSKI Variation Type to which this line applies. If it is empty, then the
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
that specify only the Discovery aspects. Current RFCs for BRSKI variations preceding this RFC typically
only specify the semantics, and this document adds the discovery aspects.

The "Dflt" Flag specifies a Variation Type Choice that is assumed to be the default Choice for the Context,
such as "rrm" for the BRSKI context. Such a Variation Type Choice is to be assumed to be supported in discovery
if discovery is performed without indication of any or an empty signaling element to carry the Variation or
Variation Choices. For example, {{BRSKI}} specifies the empty string "" as the objective-value in {{GRASP}}
discovery. Because "rrm", "est" and "cms" are default in the BRSKI context, this Discovery signaling
indicates the support for those Variation Type Choices.

The "Dflt*" Flag specifies a Variation Type Choice that is only default in a subset of Discovery options in a
context. The Note(s) column has then to explain which subset this is. Like for "Dflt", the signaling in
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

The "Variation" column lists the Variation Type Choices that form the Variation. The Variation Type Choices
MUST be listed in the order in which the Variation Types are listed in the Applicable Variation Types
column of the BRSKI Variation Contexts table.

The "Variation String" column has the string term used to indicate the variation when using the
simple encoding of BRSKI Variation Discovery for GRASP as described in {{GRASP}}. It is formed by
concatenating the Choices term from the Variation column with the "-" character, excluding those
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
(and as desired by other discovery mechanism), and it also enables to add new Variation Type and Choices
without changing pre-existing Variation Strings: Any Variations String implicitly include the Default Choice for
any future Variation Types.

When a new Variation Type is added, their Default Choice SHOULD be added to the Variation Column of existing
applicable lines in the BRSKI Discoverable Variations table. Variations that include new non-Default
Variation Type Choices SHOULD be added at the end of the existing lines for the Context.

## BRSKI Join Proxies support for Variations

### Permissible Variations

Variations according to the terminology of this document are those that do not require changes to BRSKI join proxy operations,
but that can transparently pass across existing join proxies without changes to them - as long as they support the rules
outlined in this document.

Different choices for e.g.: pledge to registrar encryption mechanisms, voucher format (vformat), use of different URI endpoints or enrollment
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
as specified by BRSKI specifications and/or discovery parameters, such as priority and weight when {{DNS-SD}} is used,
and redundant registrars include those parameters.

TBD: insert example of received Registrar announcement and created proxy announcement ??

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
for a registrar Service Name. Registrars therefore SHOULD always include the proxy functionality according
to the prior paragraph. This only involves additional code on the registrar beyond the service announcement
in case the Registrar would otherwise not implement circuit mode.

## BRSKI Pledges support for Variations

### BRSKI-PLEDGE context

BRSKI-PLEDGE is the context for discovery of pledges by nodes such as registrar-agents.
Pledges supporting {{BRSKI-PRM}} MUST support it. It may also be used by other variations of BRSKI
when supported by pledges.

Pledges supporting BRSKI-PLEDGE MUST support DNS-SD for discovery via mDNS, using link-local scope.
For DNS-SD discovery beyond link-local scope, pledges SHOULD support DNS-SD via {{I-D.ietf-dnssd-srp}}.

TBD: Is there sufficient auto-configuration support in {{I-D.ietf-dnssd-srp}}, that pledges without any
configuration can use it, and if so, do we need to raise specific additional requirements to enable this
in pledges ?

These DNS-SD requirements are defaults. Specifications for specific deployment contexts such as specific
type of radio network solutions may need to specify their own requirements overriding or amending these
requirements.

Pledges MUST support to be discoverable via their service instance name. They MAY be discoverable
via DNS-SD browsing, so that registrar-agents can find even unexpected pledges through DNS-SD browsing.

Support for browsing is required to discover over the network pledges supporting only {{BRSKI-PRM}},
but not {{BRSKI}} if they have no known serial-number information from which their service instance
name can be constructed, so it is a crucial feature for robust enrollment.  See {{security-considerations}}
for more details about discovery and BRSKI-PLEDGE.

When pledges are discoverable vis DNS-SD browsing, they MUST expect that a large number of pledges
exist in the network at the same time, such as in the order of 100 or more, and schedule their responses
according to the procedures in {{mDNS}} and {{DNS-SD}} to avoid simultaneous reply from all pledges.

TBD: What is the best section in mDNS/DNS-SD to point to for this timed reply to scale ?

Browsing via DNS-SD for a pledge is circumvented by the pledge not announcing its PTR RR for
"brski-registrar". Technically, the remaining RR may not constitute full DNS-SD service, but
they do provide the required discovery for the known service instance name of the pledge.

counter measures such as limiting the number and rate of PRM connects that they accept, ideally
on a per-initiator basis (assuming that DDoS attacks are more harder to mount than single
attacker DoS attacks).

#### Service Instance Name

The service instance name chosen by a BRSKI pledge MUST be composed from information which is

* Easily known by BRSKI operations, such as the operational personnel or software automation,
  specifically sales integration,
* Available to the pledges BRSKI software itself, for example by being encoded in some attribute of the IDevID.

Typically, a customer will know the serial number of a product from sales information, or even
from bar-code/QR-codes on the product itself. If this serial number is used as the service instance
name to discover a pledge from a registrar-agent, then this may lead to possible duplicate replies
from two or more pledges having the same serial number, such as in the following cases:

1. A manufacturer has different product lines and re-uses serial-numbers across them.
2. Two different manufacturer re-use the same serial-numbers.

If pledges enable browsing of their service instance name, they MAY support {{DNS-SD}} specified
procedures to create unique service instance names when they discover such clashes, by appending
a space and serial number, starting with 2 to the service instance name: "\<service-instance-name> (2)",
as described in {{DNS-SD}} Appendix D.

Nevertheless, this approach to resolving conflicts is not desirable:

* If browsing of DNS-SD service instance name is not supported, registrar-agents would have to
  always (and mostly wrongly) guess that there is a clash and (mostly unnecessarily) search
  for "\<service-instance-name> (2)".
* If a clash exists between pledges from the same manufacturer, and even if the registrar-agent
  then attempts to start enrolling all pledges with the same clashing service instance name,
  it may not have enough information to determine which the correct pledge is. This would happen
  especially if the IDevID from both devices (of different product type), had the same serial
  number, and the CA of both was the same (because they come from the same manufacturer).
  Even if some other IDevID field was used to distinguish their device model, the registrar-agent
  would not be able to determine that difference without additional vendor specific programming.

In result:

* Vendors MUST document a scheme how their pledges form a service instance name from
  information available to the customer of the pledge.
* These service instance names MUST be unique across all IDevID of the manufacturer that
  share the same CA.

The following mechanisms are recommended:

* Pledges SHOULD encode manufacturer unique product instance information in their
  subject name serialNumber. {{RFC5280}} calls this the X520SerialNumber.
* Pledges SHOULD make this serialNumber information consistent with easily accessible
  product instance information when in physical possession of the pledge, such as
  product type code and serial number on bar-code/QR-code to enable {{BRSKI-PRM}} discovery
  without additional backend sales integration. Note that discovery alone does not
  allow for enrollment!
* Pledges SHOULD construct their service instance name by concatenating
  their X520SerialNumber with a domain name prefix that is used by the manufacturer
  and thus allows to disambiguate devices from different manufacturer using the
  same serialNumber scheme, and hence the likelihood of service instance name clashes.

~~~~
Service Instance Name:
  "PID:Model-0815 SN:WLDPC2117A99.example.com"

Manufacturer published Service Instance Name schema:
 PID:\<PID>\\ SN:\<SN>.example.com

Pledge IDevID certificate information:
  ; Format as shown by e.g.: openssh
  Subject: serialNumber = "PID:Model-0815 SN:WLDPC2117A99",
    O = Example, CN = Model-0815

DNS-SD RR for the pledge:
  ; PTR RR to support browsing / discovery of service instance name
  _brski-pledge._tcp.local  IN PTR
    PID:Model-0815\\ SN:WLDPC2117A99\\.example\\.com._brski-pledge._tcp.local

  ; SRC and TXT RR for the service instance name
  PID:Model-0815\\ SN:WLDPC2117A99\\.example\\.com._brski-pledge._tcp.local
    IN SRV 1 1
    PID:Model-0815\\ SN:WLDPC2117A99\\.example\\.com.local
  PID:Model-0815\\ SN:WLDPC2117A99\\.example\\.com._brski-pledge._tcp.local
    IN TXT ""

  ; AAAA address resolution for the target host name
  PID:Model-0815\\ SN:WLDPC2117A99\\.example\\.com.local
    IN AAAA fda3:79a6:f6ee:0000::0200:0000:6400:00a1
~~~~
{: #service-name-example title='Example service instance name data'}

In {{service-name-example}}, the manufacturer "example" identifies device instances
through a product identifier \<PID> and a serial number \<SN>. Both are printed on labels
on the product/packaging and/or communicated during purchase of the product.

The service instance name of pledges from this manufacturer are using the
string "PID:\<PID> SN:\<SN>.example.com". "example.com" is assumed to be a
domain owned by this manufacturer. \<PID> and \<SN> are replaced by the actual
strings.

The IDevID encodes the service instance name without the domain ending (".example.com")
in the X520SerialNumber field. Other fields of the IDevID are not used.

The resulting DNS-SD RRs that the pledge announces are shown in the example.
" " and "." characters are escaped as recommended by {{DNS-SD}}.

In this example, the same string as constructed for the service instance name
is also used as the target host name. This is of course not necessary, but
unless the pledge already obtains a host name through other DNS means,
re-using the same name allows to avoid coming up with a second method to
construct a unique name.

## Variation signaling and encoding rules for different discovery mechanisms

### DNS-SD

#### Signaling

The following definitions apply to any instantiation of DNS-SD including DNS-SD via mDNS as defined in
{{DNS-SD}}, but also via unicast DNS, for example by registering the necessary DNS-SD Resource Records (RR) via {{I-D.ietf-dnssd-srp}} (SRP).

The requirements in this document do not guarantee interoperability when using DNS-SD, instead, they need to be amended
with deployment specific specifications / requirements as to which signaling variation, such as mDNS
or unicast DNS with SRP is to be supported between initiator and responder. When using unicast DNS
(with SRP), additional mechanisms are required to learn the IP / IPv6 address(es) of feasible DNS and
SRP servers, and deployment may also need agreements for the (default) domain they want to use in
unicast DNS. Hence, a mandatory to implement (MTI) profile is not feasible because of the wide range
of variations to deploy DNS-SD.

TBD: We could say that mDNS MUST be supported, unless the network context defines an interoperable
mode to support DNS-SD without mDNS ???

#### Encoding

Variation Type Choices defined in the IANA registry {{fig-variations}} are encoded as {{DNS-SD}} Keys with
a value of 1 in the DNS-SD service instances TXT RR.
This is possible because all Variation Type Choices are required to be unique across all Variation Types. It also allows to shorten
the encoding from "key=1" to just "key" for every Variation Type Choice, so that the TXT-DATA encoding can be more compact.

If the TXT Record does not contain a Variation Type Choice for a particular applicable Variation Type, then this indicates
support for the Default Choice of this Variation Type in the context of the DNS-SD Service Name. For example, if the TXT
Record is "jose", then this indicates support for "rrm" and "est", if the Service Name is brski-registrar or brski-proxy and the
protocol is TCP (BRSKI Context), but also when the protocol is UDP (cBRSKI context), because "rrm" and "est" are defaults
in both contexts.

If multiple Variation Type Choices for the same Variation Type are indicated, then this implies
that either of these Variation Type Choices is supported in conjunction with any of the other
Variation Type Choices in the same TXT Record. For example, if the TXT Record is "prm" "rrm" "cms" "jose", then
this implies support for rrm-cms-est, rrm-jose-est, prm-cms-est and prm-jose-est. This example also shows
that if the default Variation Type Choice, such as "rrm" and another Choice of the same Variation Type ("prm") are to
be indicated as supported, then both need to be included in the TXT Record.

In {{DNS-SD}}, a responder does not only indicate a Service Name, but also its Service Instance Name, which needs
to be unique across the domain to support initiators selecting a responder. This specification makes no recommendation
for choosing the Instance portion of that name. Usually it is the same, or derived from some form of pre-existing system name.

Registrars SHOULD support support their configuration without specifying a name to use in the Service Instance Name to minimize the
amount of configuration required. Registrars SHOULD support the configuration of such a name.

If the responder needs to indicate different sockets for different (set of) Variations, for example,
when operating as a proxy, according to {{proxy}}, then it needs to signal for each socket a separate Service Instance Name
with the appropriate port information in its SRV Record and the supported Variations for that socket in the TXT Record of that
Service Instance Name. In this case, it is RECOMMENDED that the Instance Name includes the Variation it supports,
such as in the format specified in {{variation}} and used in the Variation String column of the {{fig-variations}} table.

~~~~
               _brski-registrar._tcp.local
               IN PTR  0200:0000:7400._brski-registrar._tcp.local
0200:0000:7400._brski-registrar._tcp.local
                IN SRV  1 2 4555 0200:0000:7400.local
0200:0000:7400._brski-registrar._tcp.local IN TXT  "rrm" "prm"
0200:0000:7400.local
                IN AAAA  fda3:79a6:f6ee:0000::0200:0000:6400:0001

               _brski-registrar._udp.local
                IN PTR  0200:0000:7400._brski-registrar._udp.local
0200:0000:7400._brski-registrar._udp.local
                IN SRV  1 2 5684 0200:0000:7400.local
0200:0000:7400._brski-registrar._udp.local IN TXT  ""
~~~~
{: #dnssd-example-1 title='DNS-SD for a simple BRSKI and cBRSKI registrar'}

In the above example {{dnssd-example-2}}, a registrar supports BRSKI with "rrm" and "prm" modes across the same TCP socket, port 4555.
It uses "cms" voucher format and "est" enrollment, which are not included in the TXT strings because both are default for
_brski-registrar._tcp. The registrar also offers cBRSKI with "rrm" mode,  "cose" voucher and "est" enrollment on UDP port 5684,
the COAP over DTLS default port. The TXT RR for this has only an empty string because "rrm", "cose" and
"est" are default for cBRSKI.

As the instance name, the registrar uses in this example the MAC address "0200:0000:7400", which is
MAC address of the interface on which the registrar has the IPv6 address "fda3:79a6:f6ee:0000::0200:0000:6400:0001".
The registrar should know that this MAC address is globally unique (assigned by IEEE). Else it should instead
use its IPv6 address as the Instance Name. For example, if the registrar is just a software application not
knowing the specifics of the hardware it is running on, the MAC address MUST NOT be used. If only mDNS is used
(as in this example), then the IPv6 link-local address would also suffice as the Instance Name.

In this example, a single Instance Name suffices, because BRSKI and cBRSKI are two separate service
contexts: they are distinguished by different protocols: TCP vs. UDP.

~~~~
0123456789012345678901234567890123456789012345678901234567890123456789
                   _brski-registrar._tcp.local
               IN PTR  0200:0000:7400-rrm._brski-registrar._tcp.local
0200:0000:7400-rrm._brski-registrar._tcp.local
               IN SRV  1 2 4555 0200:0000:7400-rrm.local
0200:0000:7400-rrm._brski-registrar._tcp.local IN TXT ""
0200:0000:7400-rrm.local
               IN AAAA fda3:79a6:f6ee:0000::0200:0000:6400:0001

                   _brski-registrar._tcp.local
               IN PTR 0200:0000:7400-prm._brski-registrar._tcp.local
0200:0000:7400-prm._brski-registrar._tcp.local
               IN SRV 1 2 4555 0200:0000:7400-prm.local
0200:0000:7400-prm._brski-registrar._tcp.local
               IN TXT "prm" "cmp"
0200:0000:7400-prm.local
               IN AAAA fda3:79a6:f6ee:0000::0200:0000:6400:0001
~~~~
{: #dnssd-example-2 title='DNS-SD for a BRSKI registrar supporting RRM and PRM'}

In the second example {{dnssd-example-2}}, a registrar needs to use two different Instance Names, because both
share the same service context: BRSKI - TCP with service name brski-registrar. In this example, the registrar
offers "rrm" mode with "cms" voucher and "est" enrollment. It also offers "prm" mode with "cms" voucher,
but (only) with "cmp" enrollment protocol. Because the registrar does not offer "rrm" with "cmp", or
"prm" with "est", it is not possible to coalesce all variations under one Instance Name, so instead, two
Instance Names have to be created, and with them the necessary (duplicate) RR.

Note that the "-rrm" and "-prm" in the Instance Names are only explanatory and could be any mutually unique
strings - as is true for the whole Instance Name.

Note too, that because both Instances share the same port number 4555 (and hence TCP socket), they both have
to be provided by the same BRSKI application. If two separate applications where to be started on the
dame host, one for "rrm", the other for "prm", then they would have separate sockets and hence port numbers.

### GRASP {#grasp}

#### Signaling

This document does not specify a mandatory to implement set of signaling options to guarantee
interoperability of discovery between initiator and responders when using GRASP. Like for the
other discovery mechanisms, these requirements will have to come from other specifications
that outline what in {{GRASP}} is called the "security and transport substrate" to be used for
GRASP.

{{RFC8994}} specifies one such "security and transport substrate", which is zero-touch deployable.
It is mandatory to support for initiators and responders implementing the so-called
"Autonomic Network Infrastructure" (ANI). DULL GRASP is used for link-local discovery of
proxies, and the ACP is used to automatically and securely build the connectivity for multi-hop discovery
of registrars by proxies.

#### Encoding

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
     h'fe800000000000000000000000000001', IPPROTO_TCP, 4443],
     ["AN_Proxy", 4, 1, "prm",
     [O_IPv6_LOCATOR,
     h'fe800000000000000000000000000001', IPPROTO_TCP, 4443],
     ["AN_Proxy", 4, 1, "",
     [O_IPv6_LOCATOR,
     h'fe800000000000000000000000000001', IPPROTO_UDP, 4684]]
]
~~~~
{: #grasp-example-1 title='GRASP example for a BRSKI registrar supporting RRM and PRM'}

{{grasp-example-1}} is an example for a GRASP service announcement for "AN_Proxy" in support of BRSKI
with both "rrm" and "prm" supported on the same socket (TCP port number) and for cBRSKI with
COAP over DTLS.

Note that one or more complete service instances (in the example 3) can be contained within a single GRASP message
without the need for any equivalent to the Service Instance Name of the DNS-SD PTR RR or the
Target name of the DNS-SD SRV RR. DNS-SD requires them because its encoding is
decomposed into different RR, but it also intentionally introduces the Service Instance Name
as an element for human interaction with selection (browsing and/or diagnostics of selection),
something that the current GRASP objective-value encoding does not support.

Because this GRASP encoding does not support service instance name, examples such as

~~~~
[M_FLOOD, 12340815, h'fe800000000000000000000000000001', 180000,
    [["AN_Proxy", 4, 1, "",
     [O_IPv6_LOCATOR,
     h'fe800000000000000000000000000001', IPPROTO_TCP, 4443],
     ["AN_Proxy", 4, 1, "",
     [O_IPv6_LOCATOR,
     h'fe800000000000000000000000000001', IPPROTO_UDP, 4684]]
]

[M_FLOOD, 42310815, h'fe800000000000000000000000000001', 180000,
    [["AN_Proxy", 4, 1, "prm",
     [O_IPv6_LOCATOR,
     h'fe800000000000000000000000000001', IPPROTO_TCP, 44000]]
]
~~~~
{: #grasp-example-2 title='GRASP example with two different processes'}

In {{grasp-example-2}}, A separate application process supports "prm" and hence
uses a separate socket, with example TCP port 44000. In this case, there is
no need nor significant benefit to merge all service instance announcements into
a single GRASP message. Instead, the BRSKI-"rrm"/cBRSKI process would be
able to generate and send its own, first, message shown in the example, and the
second process would send its own, second message in the example.

For a more extensive, DNS-SD compatible encoding of the objective-value that also
support Service Instance Names, see {{I-D.eckert-anima-grasp-dnssd}}.

### CORE-LF

"Web Linking", {{RFC5988}} defines a format, originally for use with
HTTP headers, to link an HTTP document against other URIs. Web linking is not a standalone
method for discovery of services for use with HTTP.

Based on Web Linking, "Constrained RESTful Environments (CoRE) Link Format", {{CORE-LF}} introduces a
stand alone method to discover services instances, which are called resources in CORE-LF;
primarily for use with {{COAP}} but equally for use with, for use with HTTP or any other suitable web transfer protocols.

In CORE-LF, an initiator may use (link-local) IPv6 multicast UDP packet to the COAP port (5683)
to discover a a possible responder for a specifically requested resource. The responder will reply with unicast UDP.
If the IPv6 address of a responder has been configured or is otherwise known to the initiator, it
may equally query the parameters of the desired resource via unicast to the default COAP UDP or
TCP port (5683).

A service such as BRSKI registrar, join proxy or pledge can be considered to be a resource, but it
can equally be broken down into a set of component resources resources, in which case the group
can be requested. As mentioned above, CORE-LF can equally be used to request and discover resources
not using COAP, but any other suitable protocol.

{{RFC9176}} defines a "Resource Directory" mechanism for CORE-LF which is abbreviated CORE-RD. Initiators
can learn the IPv6 address protocol (TCP or UDP) and port numberaof a CORE-RD server by some other
mechanism (such as DNS-SD) and then use a unicast UDP or TCP COAP connection to the CORE-RD server
to discover CORE-LF resources available on other systems. Resource providers can likewise register
their resources with the resource directory server using CORE-RD registration procedures.

In summaery, CORE-LF including CORE-RD is a mechanism for registration and discovery of resources and
hence services which may be preferred in deployments over other options and can equally be applicable
to register/discover any variation of BRSKI for any type of BRSKI service.

#### Signaling

##### Existing definitions

{{cBRSKI}} specifies the use of CORE-LF as a reference methods
for pledges to discover registrars - in the absence of any proxies, to allow deployments
of scenarios where no proxies are needed - and hence also where {{cBRSKI}}.
is not needed. Because BRSKI is designed so that pledges can be agnostic of whether they connect
to a registrar directly or via a proxy, the resource/service that the pledge needs to discover
is nevertheless called "(brski) join proxy (for pleges)", and encoded in CORE-LF as the value
"brski.jp" for the resource type attribute ("rt=resource-type") according to {{CORE-LF}}.

The following picture, {{corelf-example-1}} shows the encoding and an example of this discovery.
"ff02::fd" is the link-local scope address for "All Coap Nodes" in IPv6, as introduced in {{RFC7390}},
which also defines IPv6 and site-scoped address options.

~~~~
Template:

REQ: GET coap://[All_Coap_Nodes_IP_multicast_addr]/.well-known/core?rt=brski.jp

RES: 2.05 Content
   <coaps://[Responder_IP_unicast_address]:join-port>; rt="brski.jp"

Example:

REQ: GET coap://[ff02::fd]/.well-known/core?rt=brski.jp

RES: 2.05 Content
   <coaps://[fe80::c78:e3c4:58a0:a4ad]:8485>;rt=brski.jp
~~~~
{: #corelf-example-1 title='CORE-LF discovery of registrar/proxy by pledges'}

{{cPROXY}} introduces the operations of a CoAP based join proxy
both as a connection based proxy as in {{BRSKI}} (only using UDP connections for COAPs instead
of TCP for TLS as in {{BRSKI}}), but also as a new, stateless join proxy - to eliminate the
need for potentially highly constrained join proxy nodes to keep connection state and avoid
the complexity of protecting that state against attacks. The new resource type "brski.rjp" is
defined to support stateless join proxies to discover registrars and their UDP port number
that support the stateless, so-called JPY protocol.

The following picture, {{corelf-example-2}} shows the encoding and an example of this discovery.
{{cPROXY}} introduces the new scheme "coaps+jpy" for the packet
header used by the stateless JPY" protocol. The request in the template is assumed to be
based on unicast, relying on another method to discover the IP address of the registrar first.
It could equally use COAP site-scoped IP multicast, but in general, the assumeption is that
registrar will not necessarily be link-local connected to proxies (this may be different in
specific deployments). Even though the registrar IP address is hence known, the reply still
needs to include this address again because in the {{RFC6690}} link format, and {{RFC3986}}, Section 3.2, the
authority attribute can not include a port number unless it also includes the IP address.

~~~~
Template:

REQ: GET /.well-known/core?rt=brski.jpy

RES: 2.05 Content
     <coaps+jpy://[Responder_IP_unicast_address]:join-port>;rt=brski.jpy

Example:

REQ: GET /.well-known/core?rt=brski.jpy

RES: 2.05 Content
     <coaps+jpy://[2001:db8:0:abcd::52]:7633>;rt=brski.jpy
~~~~
{: #corelf-example-2 title='CORE-LF discovery of registrars that support stateless JPY protocll by proxies'}

##### New variation discovery

This document expands the above summarized existing CORE-LF definitions from
{{cBRSKI}} and {{cPROXY}} as follows.

Discovery of stateful sockets on a registrar uses the resource type "brski.rs" (for
"registrar (for) join proxies stateful)" - instead of "brski.rjpy" for the previosly
defined stateless connection mode.

The following picture {{corelf-example-3}} show template and example of this discovery option.
In Example 1, the registrar is running on a separate port 7634 from the COREs UDP port, so
this response needs to also include the IP address of the responding registrar (as explained
above). In Example 2, the registar functions are provided via the default (potentially shared)
COAPS port, so this is not necessary. In both cases, the response include a shorter URL part
"/b/s" which allows that the service can be used via that shorter prefix than the default
"/.well-known/brksi", hence shortening the required COAPS packet sizes.

~~~~
Template:

REQ: GET /.well-known/core?rt=brski.r(*|s|spy)

RES: 2.05 Content
     <scheme://[Responder_IP_unicast_address]:join-port>;rt=brski.(rjpy|rs)

Example 1:

REQ: GET /.well-known/core?rt=brski.rs

RES: 2.05 Content
     <coaps://[2001:db8:0:abcd::52]:7634/b/s>;rt=brski.rs

Example 2:

REQ: GET /.well-known/core?rt=brski.rjpy

RES: 2.05 Content
     </b/s>;rt=brski.rjpy
~~~~
{: #corelf-example-3 title='CORE-LF discovery of registrars that support stateless JPY protocll by proxies'}

TBD: Question: can we really reply without coaps given how we always want coaps - aka: the query itself
may not have been coaps ?? This is  question for constrained proxy/voucher - can we rightfully (according to
IETF specs) make the expection that even though the resource discovery is done insecure, that it is understood
that the actual resource consumption has to use coaps ????  - question for COAP experts.

Explanations:

The discovery and distinction between a stateless and stateful registrar socket is orthogonal
to the concept of a variation of BRSKI as defined in this document. Therefore, the distinction
between a stateless and stateless socket on a registrar is provided solely via the CORE-LF
resource-type, "brski.rjpy" (stateless) and "brski.rs" (stateful). In other words, the "rt"
attribute in CORE-LF serves as the abstract "Service Name" in this document. If discover
of stateless join proxies was required with other discovery mechanisms such as GRASP or
DNS-SD, then new "Service Name" equivalents in those discovery mechanisms would need to be
defined. For the purpose of this document, it is assumed that stateless proxy operations
is well enough supported with CORE-LF.

To indicate variations other than the default combination implied by {{cBRSKI}}
and {{cPROXY}}, this document specifies the new "bv" (brski variation)
attribute for CORE-LF records, which is specified relative only to "rt=brski.r*" resource targets.

The value to the "bv=" attribute is a flattened string of the non-default Variation Type Choices
as specified for GRASP, so that CORE-LF does not introduce another registry table to maintain.
The only difference is that the absence of the "bv=" attribute is equivalent to the
actual defaults established by {{cBRSKI}} and {{cPROXY}},
namely "rrm" (registrar response-mode) with "cose" (CBOR with COSE signed voucher) and "est" - enrollment
via the 'fitting' variation of EST, in the case of using COAPS it is {{RFC9148}}, e.g.: EST over COAPS.
Including or excluding "bv=" (empty value) is hence equivalent to "bs=cose", aka: the default variation
over COAPS.

When a variation implies use of HTTPS (or in the future any other transport other than COAPS), then
the schema, and hence IP-address needs to be included in the CORE-LF response. Likewise, even if the
protocol schema is coaps, then the IP address needs to be included if the resource is not served on
the standard COAPS UDP port.

\[ Q: How does the schema indicate UDP versus TCP for COAPS ??? ]

The following {{corelf-example-4}} shows the schema and an example for various BRSKI registar
variations, discovered via CORE-LF.

"rt=brski.rs" with schema "coaps" and without any "bv" attribute indicate the default combination
of "rrm", "cose" and "est" (EST via COAPS), as introduced by {{I-D.ietf-anima-constrained-voucher}},
aka: stateful cBRSKI.

"rt=brski.rjpy" with schema "coaps+jpy" and without any "bv" attribute indicate the default combination
of "rrm", "cose" and "est" (EST via COAPS), as introduced by {{I-D.ietf-anima-constrained-join-proxy}},
aka: stateless proxy cBRSKI, using the JPY header.

In both cases, there is no "bv=" attribute, so that the absence of the "bv" attribute indicates
backward compatibility with existing definitions from {{I-D.ietf-anima-constrained-voucher}} and
{{I-D.ietf-anima-constrained-join-proxy}}.

"rt=brski.rs" with schema "https" and with "bv=" indicates {{BRSKI}} with its default variation
of "rrm", "cms" and "est". As there is no mechanism to support the JPY header via TCP (for https),
there is no schema "https+jpy" option.

"rt=brski.rs" with schema "https" and with "bv=cmp" indicates the variation "rrm", "cms" and "cmp"
as introduced by {{BRSKI-AE}}, and "rt=brski.rs" with schema "https" and with "bv=prm-jose" indicates
 the variation "prm", "jose" and "cmp" as introduced by {{BRSKI-PRM}}.

Note that the variation type value of "est" does mean different protocol specifications depending
on the transport. Over "https" it means {{EST}}, whereas over COAPS it means {{RFC9148}}.

~~~~
Template:

REQ: GET /.well-known/core?rt=brski.r*

RES: 2.05 Content
     <scheme://[Responder_IP_unicast_address]:join-port>;\
       rt=brski.r*(;brv=brski-variation-string)

Example:

REQ: GET /.well-known/core?rt=brski.r*

RES: 2.05 Content
     <coaps://[2001:db8:0:abcd::52]:7634/b>;rt=brski.rs,
     <coaps+jpy://[2001:db8:0:abcd::52]:7633/b>;rt=brski.rjpy,
     <https://[2001:db8:0:abcd::52]:7634/b>;rt=brski.rs;bv=,
     <https://[2001:db8:0:abcd::52]:7634/b>;rt=brski.rs;bv=cmp,
     <https://[2001:db8:0:abcd::52]:7634/b>;rt=brski.rs;bv=prm-jose,
~~~~
{: #corelf-example-4 title='CORE-LF discovery of registrars by a proxy for different BRSKI variations'}

The following {{corelf-example-5}} shows variations that have not explicitly been defined
in existing specifications, so it is more or less unless whether they will work withough
additional specification of details to allow interoperability. Specifically, it is unclear
whether "endpoint" protocols defined for "http" transport will equall work over "coaps"
transport without additional specification.

For this reason, such variations are not explicitly assumed to be supportable, but included
as candidarte, subject to additional specification, and/or expert review.

~~~~
RES: 2.05 Content
     <coapsy://[2001:db8:0:abcd::52]:7633/b>;rt=brski.rsy;bv=cose-cmp,
     <coaps+jpy://[2001:db8:0:abcd::52]:7633/b>;rt=brski.rjpy;bv=cose-cmp,
     <https://[2001:db8:0:abcd::52]:7634/b2>;rt=brski.rjps;bv=jose-cmp,
     <https://[2001:db8:0:abcd::52]:7634/b3>;rt=brski.rjps;bv=cose-cmp
~~~~
{: #corelf-example-5 title='Potential ? future registrar variations'}


\[ Q: Can we actually use the * discovery to only discover the two variations of
registrar transport variations "rj*" - when we are a registrar ??? we do not want to
discover the resource that proxies or registrars provide to pledges!!! ]

When pledges need to discover (and select)  proxies (or registrars) supporting a specific
combination of variations, the encoding of attributes is the same as shown in
{{corelf-example-3}} except that now, "rt=brski.jp" needs to be discovered.

It is a responsibility of the proxy to discover registrars and map their discovered "bv=" variations
for rt=brski.rjp" and/or "brski.rjps" to the same "bv=" variations to their announced "rt=brski.jp"
resources: For provies, there is simply a 1:1 mapping of the "bv" attribute and the connection scheme
for the resources discovered from registrars, except for the subset of variations that can rely
on COAPS transport, for those both the "rt=brski.rjp" and "rt=brski.rjps" are options how to
proxy the resource for the pleges.

Note that the port numbers announced by the proxy resources will of course likely be different than
those announced by the registarars.

~~~~
Template:

REQ: GET /.well-known/core?rt=brski.jp

RES: 2.05 Content
     <scheme://[Responder_IP_unicast_address]:join-port>;\
         rt=brski.jp(;brv=brski-variation-string)

Example:

REQ: GET /.well-known/core?rt=brski.rj*

RES: 2.05 Content
     <coaps://[2001:db8:0:abcd::52]:7734/b>;rt=brski.jp,
     <https://[2001:db8:0:abcd::52]:7734/b>;rt=brski.jp;bv=,
     <https://[2001:db8:0:abcd::52]:7734/b2>;rt=brski.jp;bv=jose-cmp,
     <https://[2001:db8:0:abcd::52]:7734/b3>;rt=brski.jp;bv=cose-cmp
~~~~
{: #corelf-example-6 title='CORE-LF discovery of registrars or proxies by pledges for various BRSKI variations'}

# Updates to existing RFCs

## RFC8995

TBD.

# IANA considerations

## BRSKI Variations Discovery Registry (section) {#registry}

This document requests a new section named "BRSKI Variations Discovery Parameters"
in the "Bootstrapping Remote Secure Key Infrastructures (BRSKI) Parameters"
registry (https://www.iana.org/assignments/brski-parameters/brski-parameters.xhtml).
Its initial content is as follows.

\[ RFC editor. Please remove the following sentence.
Note to IANA: This section contains three tables according to the specifications of this document.
Each of these tables should include the table title so that they can be more easily
distinguished.  If it is not possible to introduce more than one table per section, then we will modify the request
accordingly for three sections, but given how the three tables are tightly linked, that would be unfortunate. ]

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


| Context         | Applicable Variation Types | Discovery Mechanism| Service Name(s)|
|:----------------|:---------------------------|:----------|:--------------|
| BRSKI           | mode<br>vformat<br>enroll  | GRASP     |  "AN_join_registrar" /<br> "AN_Proxy"<br>with IPPROTO_TCP |
|                 |                            | DNS-SD    |  "brski-registrar" /<br> "brski-proxy"<br> with TCP|
| cBRSKI          | mode<br>vformat<br>enroll  | GRASP     | "AN_join_registrar" /<br> "AN_join_registrar_rjp" /<br> "AN_Proxy"<br> with IPPROTO_UDP |
|                 |                            | DNS-SD    | "brski-registrar" /<br> "brski-proxy"<br> with UDP |
|                 |                            | CORE-LF   | rt=brski.*|
| BRSKI-PLEDGE    | mode<br>vformat<br>enroll  | DNS-SD    | "brski-pledge" with TCP |
{: #fig-contexts title="BRSKI Variation Contexts"}


|Context         |Variation Type | Variation <br>Type Choice | Reference | Flags | Note(s)                                                |
|:----------------|:--------|:----------|:-----------------------|:-----|:---------------------------------------------------------------------|
| BRSKI, cBRSKI   | mode    | rrm       | {{RFC8995}}<br>ThisRFC   | Dflt | Registrar Responder Mode <br> the mode specified in {{RFC8995}}      |
|                 |         | prm       | ThisRFC  <br>          |      | Pledge Responder Mode    <br> {{I-D.ietf-anima-brski-prm}}           |
| BRSKI           | vformat | cms       | {{RFC8368}}<br>ThisRFC   | Dflt | CMS-signed JSON Voucher  <br>                                        |
|                 |         | cose      | ThisRFC<br>            |      | CBOR with COSE signature<br>                                |
| cBRSKI          |         | cose      | ThisRFC<br>            | Dflt | CBOR with COSE signature <br> {{I-D.ietf-anima-constrained-voucher}} |
|                 |         | cms       | {{RFC8368}}<br>ThisRFC   |      | CMS-signed JSON Voucher  <br>                                        |
| BRSKI, cBRSKI   |         | jose      | ThisRFC<br>            |Dflt* | JOSE-signed JSON, Default when prm is used<br> {{I-D.ietf-anima-jws-voucher}}, {{I-D.ietf-anima-brski-ae}} |
| BRSKI-PLEDGE    | mode    | prm       | ThisRFC                | Dflt | Pledge responder Mode<br>{{I-D.ietf-anima-brski-prm}} |
|                 | vformat | jose      | ThisRFC                | Dflt | JOSE-signed JSON, Default when prm is used<br> {{I-D.ietf-anima-jws-voucher}}, {{I-D.ietf-anima-brski-ae}}  |
|                 |         | cms       | ThisRFC                | Rsvd | CMS-signed JSON Voucher, not specified. |
|                 |         | cose      | ThisRFC                | Rsvd | CBOR with COSE signature, not specified. |
| BRSKI, cBRSKI, BRSKI-PLEDGE  | enroll  | est       | {{RFC8995}}<br>{{RFC7030}} | Dflt | Enroll via EST           <br> as specified in {{RFC8995}}, extension for {{BRSKI-PRM}} when used in context BRSKI-PLEDGE<br}{{RFC9148}} when used over COAP |
|                 |         | cmp       | ThisRFC                |      | Lightweight CMP Profile  <br> {I-D.ietf-anima-brski-ae}}, {{I-D.ietf-lamps-lightweight-cmp-profile}} |
|                 |         | scep      | ThisRFC                | Rsvd | {{RFC8894}}                                                          |
{: #fig-choices title="BRSKI Variation Type Choices"}

Note 1:
: The Variation String "EST-TLS" is equivalent to the Variation String "" and is required and only permitted for the AN_join_registrar objective value in GRASP for backward compatibility with RFC8995, where it is used for this variation. Note that AN_proxy uses "".

|Context  |Reference                              |Variation String |Variations    | Explanations / Notes|
|:--------|:--------------------------------------|:----------------|:-------------|:--------------------|
| BRSKI   |[RFC8995]                              | "" / "EST-TLS"  | rrm cms  est | Note 1              |
|         |{{I-D.ietf-anima-brski-ae}}            | cmp             | rrm cms  cmp |                     |
|         |{{I-D.ietf-anima-brski-prm}}           | prm-jose        | prm jose est |                     |
|         |                                       |                 |              |                     |
| cBRSKI  |{{I-D.ietf-anima-constrained-voucher}} | "" / "rrm-cose" | rrm cose est |                     |
{: #fig-variations ="BRSKI Discoverable, well specified Variations"}

## Service Names Registry

IANA is asked to modify and amend the "Service Name and Transport Protocol Port Number Registry" registry (https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.txt) as follows:

brski-proxy and brski-registrar are to be added as Service Names for the "udp" protocol using ThisRFC as the reference.

The registrations for brski-proxy and brski-registrar for the "tcp" protocol are to be updated to also include ThisRFC as their reference.

The Defined TXT keys column for brski-proxy and brski-registrar for both "tcp" and "udp" protocols are to state the following text:

See ThisRFC and the "BRSKI Variation Type Choices" table in the "Bootstrapping Remote Secure Key Infrastructures (BRSKI) Parameters" registry.

TBD: This request likely does not include all the necessary formatting.

## BRSKI Well-Known URIs fixes (opportunistic)

The following change requests to "https://www.iana.org/assignments/brski-parameters/brski-parameters.xhtml#brski-well-known-uris" are cosmetic in nature and are included in this document solely because support for Endpoint URIs is implied by the mechanisms specified in this document and the existing registry has these cosmetic issues.

1. IANA is asked to change the name of the first column of the table from "URI" to "URI Suffix". This is in alignment with other table columns with the same syntax/semantic, such as "https://www.iana.org/assignments/well-known-uris/well-known-uris.xhtml".

2. IANA is asked to change the Reference from {{RFC8995}} to {{RFC8995, Section 8.3.1}}.

3. IANA is asked to include the following "Note" text: The following table contains the assigned BRSKI protocol Endpoint URI suffixes under "/.well-known/brski"." - This note is added to introduce the term "Endpoint" into the registry table as that is the term commonly used (instead of URI) in several of the memos for which this discovery document was written. It is meant to help readers map the registry to the terminology used in those documents.

# Security Considerations {#security-considerations}

In {{BRSKI-PRM}}, pledges are easier subject to DoS attacks than in {{BRSKI}}, because attackers
can be initiators and delay or prohibit enrollment of a pledge by opening so many connections to
the pledge that a valid registrar-agents connection to the pledge may not be possible. Discovery
of the pledge via DNS-SD increases the ability of attackers to discover pledges against which such
DoS attacks can be attempted.

Especially when supporting DNS-SD browsing across unicast DNS,
Pledges MUST implement DoS prevention measures, such as limiting the number and rate of accepted TCP
connections on a per-initiator basis. If feasible for the implementation, simultaneous connections
SHOULD be possible, so that an ongoing attacker connection will not delay a valid registrar-agent
connection. When accepting connections, a strategy such as LRU MAY be used to ensure that an attacker
will not be able to monopolize connections.

Browsing via DNS-SD, especially via unicast DNS which makes information available network-wide does
also introduce a perpass attack, gathering intelligence against what type and serial number of
devices are installed in the network. Whether or not this is seen as a relevant risk is highly
installation dependent. Networks SHOULD implement filtering measures at mDNS and/or DNS RR/services
level to prohibit such data collection if there is a risk, and this is seen as an undesirable attack
vector.

# Acknowledgments

TBD.

# Draft considerations

## Open Issues

Questions to the DNS-SD community.

TBD

## Change log

\[RFC Editor: please remove this section.]

WG draft 02/03:

Fix up tables to be correctly rendered by html output.

WG draft 01:

Core-LF improvements  / interim work.

WG draft 00:

Added section for CORE-LF. Still missing to update existing text with the CORE-LF definitions.

Individual version 01:

Various enhancements

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
variations signaled via the objective-value field of GRASP objectives.

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

* Stateless JPY proxy operations is indicated with objective-name "AN_join_registrar_rjp" and IPPROTO_UDP.
  The default for AN_join_registrar/UDP is the use of COAPs and CBOR encoded voucher. For this
  default, the objective-value is "".

# Possible future variations {#future}

The following table {{fig-future-variations}} shows possible future entries for "Variation String" if
there is an interest for such a variation. Thesew would be subject to expert review and could
hence require appropriate additional specification so that interoperability based on that variation string
can be guaranteed.

| Context | Reference                   | Variation String| Variations | Explanations / Notes|
|:--------|:----------------------------|:--------------|:----------|:------------|
| BRSKI   | -                           | jose          | rrm jose est |possible variation of {{RFC8995}} with voucher according to {{I-D.ietf-anima-jws-voucher}} |
|         | -                           | jose-cmp      | rrm jose cmp |possible variation of {{RFC8995}} with voucher according to {{I-D.ietf-anima-jws-voucher}} and enrollment according to {{I-D.ietf-lamps-lightweight-cmp-profile}} |
|         | -                           | cose          | rrm cose est |possible variation of {{RFC8995}} with voucher according to {{I-D.ietf-anima-constrained-voucher}} |
|         | -                           | cose-cmp      | rrm cose cmp |possible variation of {{RFC8995}} with voucher according to {{I-D.ietf-anima-constrained-voucher}} and enrollment according to {{I-D.ietf-lamps-lightweight-cmp-profile}} |
|         | -                           | prm-cmp       | prm jose cmp |possible variation of {{I-D.ietf-anima-brski-prm}} and {{I-D.ietf-anima-brski-ae}} |
|         | -                           | prm-cose      | prm cose est |possible variation of {{I-D.ietf-anima-brski-prm}} and {{I-D.ietf-anima-constrained-voucher}} |
|         | -                           | prm-cose-cmp  | prm cose cmp |possible variation of {{I-D.ietf-anima-brski-prm}}, {{I-D.ietf-anima-constrained-voucher}} and {{I-D.ietf-anima-brski-ae}} |
{: #fig-future-variations ="Candidate future BRSKI Discoverable Variations"}

