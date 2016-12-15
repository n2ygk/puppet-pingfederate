#!/usr/bin/env python
# parse the XML for the configured JDBC connectors and create custom facts
# Ignores the builtin hsqldb
# TODO: replace this with JSON output from pf-admin-api instead.
# TODO: make the pathname configurable.
from xml.dom.minidom import parse
try:
    dom1 = parse('/opt/pingfederate/server/default/data/pingfederate-jdbc-ds.xml')
except:
    exit(0)
for ds in dom1.getElementsByTagName('datasources'):
    for tx in ds.getElementsByTagName('local-tx-datasource'):
        description = jndiname = url = None
        for kid in tx.childNodes:
            if kid.nodeName == 'description':
                description = kid.childNodes[0].data
            if kid.nodeName == 'jndi-name':
                jndiname = kid.childNodes[0].data
            if kid.nodeName == 'connection-url':
                url = kid.childNodes[0].data
        if 'jdbc:' in description and 'jdbc:hsqldb' not in description:
            # the JDBC URL becomes the fact name
            # strip out the URL parameters. 
            q = description.find('?')
            if q > 0:
                description = description[:q]
            print("%s=%s"%(description,jndiname))
            

            
