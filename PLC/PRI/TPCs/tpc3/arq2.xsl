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
                        <xsl:apply-templates mode="indice" select="//ARQELEM">
                            <xsl:sort select="INDENTI"/>
                        </xsl:apply-templates>
                    </ul>
                </body>
            </html>
        </xsl:result-document>
        <xsl:apply-templates/>
        
    </xsl:template>
    
    <!-- ///// Templates para os indices ///// -->
    <xsl:template match="ARQELEM" mode="indice">
        <li>
            <a name="i{generate-id()}"/> <!-- bookmark -->
            <!-- tenho q ter em conta se estou posicionado no mesmo nodo que a bookmark -->
            <a href="{generate-id()}.html"> <!-- links externos -->
                <xsl:value-of select="IDENTI"/>
            </a>
        </li>        
    </xsl:template>
    
    <!-- ///// Templates para o Conteúdo ///// -->
    <xsl:template match="ARQELEM">
        <xsl:result-document href="tabsite/{generate-id()}.html">
            <html>
                <head>
                    <title>
                        <xsl:value-of select="IDENTI"/>
                    </title>
                </head>
                <body>
                    <a name="{generate-id()}"/> <!-- bookmarks feitas -->
                    <p><b>Identificação:</b> <xsl:value-of select="IDENTI"/></p>
                    <p><b>Freguesia - Concelho:</b> <xsl:value-of select="FREGUE"/> - <xsl:value-of select="CONCEL"/></p>
                    <p><b>Descrição:</b> <xsl:value-of select="DESCRI"/></p>
                    <!-- Testa se existe -->
                    <xsl:if test="LATITU">
                        <p><b>Latitute:</b> <xsl:value-of select="LATITU"/></p>
                    </xsl:if>
                    <xsl:if test="LONGIT">
                        <p><b>Longitude:</b> <xsl:value-of select="LONGIT"/></p>
                    </xsl:if>
                    <xsl:if test="ALTITU">
                        <p><b>Altitude:</b> <xsl:value-of select="ALTITU"/></p>
                    </xsl:if>
                    <xsl:if test="ACESSO">
                        <p><b>Acesso:</b> <xsl:value-of select="ACESSO"/></p>
                    </xsl:if>
                    <p><b>Desenho Arquiteturial: </b> <xsl:value-of select="DESARQ"/></p>
                    <address>[<a href="index.html#i{generate-id()}">Voltar ao Indice</a>]</address>
                </body>
            </html>
        </xsl:result-document>
        <!-- <address>[<a href="#indice">Voltar ao Indice</a>]</address> -->
        <center><hr width="80%"/></center>
    </xsl:template>
    
    
</xsl:stylesheet>