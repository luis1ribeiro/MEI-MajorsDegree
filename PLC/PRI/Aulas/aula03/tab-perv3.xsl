<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <xsl:result-document href="tabsite/index.html">
            <html>
                <head>
                    <title> Tabela Periódica dos Elementos </title>
                </head>
                <body>
                    <h3>Índice</h3>
                    <!-- travessia indice -->
                    <ul>
                        <xsl:apply-templates mode="indice" select="//ATOM">
                            <xsl:sort select="SYMBOL"/>
                        </xsl:apply-templates>
                    </ul>
                </body>
            </html>
        </xsl:result-document>
        <xsl:apply-templates/>
        
    </xsl:template>
    
    <!-- ///// Templates para os indices ///// -->
    <xsl:template match="ATOM" mode="indice">
        <li>
            <a name="i{generate-id()}"/> <!-- bookmark -->
                <!-- tenho q ter em conta se estou posicionado no mesmo nodo que a bookmark -->
            <a href="{generate-id()}.html"> <!-- links externos -->
                 <xsl:value-of select="SYMBOL"/>
                -
                <xsl:value-of select="NAME"/>
            </a>
        </li>        
    </xsl:template>
    
    <!-- ///// Templates para o Conteúdo ///// -->
    <xsl:template match="ATOM">
        <xsl:result-document href="tabsite/{generate-id()}.html">
            <html>
                <head>
                    <title>
                        <xsl:value-of select="NAME"/>
                    </title>
                </head>
                <body>
                    <p><b>Nome:</b> <xsl:value-of select="NAME"/></p>
                    <p><b>Peso atómico:</b> <xsl:value-of select="ATOMIC_WEIGHT"/></p>
                    <p><b>Número atómico:</b> <xsl:value-of select="ATOMIC_NUMBER"/></p>
                    <!-- Testa se existe -->
                    <xsl:if test="HEAT_OF_FUSION">
                        <p><b>Ponto de fusão:</b> <xsl:value-of select="HEAT_OF_FUSION"/> <xsl:value-of select="HEAT_OF_FUSION/@UNITS"/></p></xsl:if>
                </body>
            </html>
        </xsl:result-document>
            <address>[<a href="index.html#i{generate-id()}">Voltar ao Elemento-Indice</a>]</address>
        <!-- <address>[<a href="#indice">Voltar ao Indice</a>]</address> -->
        <center><hr width="80%"/></center>
    </xsl:template>
    
    
</xsl:stylesheet>