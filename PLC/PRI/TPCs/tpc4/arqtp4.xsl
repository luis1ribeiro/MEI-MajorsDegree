<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">

    <xsl:output method="html" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <xsl:result-document href="arqs/index.html">
            <html>
                <head>
                    <title> Arquiosstios do NW Português </title>
                </head>
                <body>
                    <h3>Índice</h3>
                    <!-- travessia indice -->
                    <ul>
                        <xsl:apply-templates select="//ARQELEM[not(CONCEL=preceding::CONCEL)]">
                            <!-- tenho q normalizar os espaços no sort, a parte do valueof -> o html trata disso -->
                            <xsl:sort select="normalize-space(CONCEL)"/>
                        </xsl:apply-templates>
                    </ul>
                </body>
            </html>
        </xsl:result-document>
        <xsl:apply-templates select="//ARQELEM" mode="individual">
        </xsl:apply-templates>
        <xsl:apply-templates/>

    </xsl:template>

    <xsl:template match="ARQELEM">
        <!-- para não haver ambiguidade no xsl em baixo do concelho, cria-se uma variável -->
        <xsl:variable name="c" select="CONCEL"/>
        <li>
            <!-- Ordenar dentro do Concelho -->
            <xsl:value-of select="CONCEL"/>
            <ul>
                <xsl:apply-templates mode="subindice" select="//ARQELEM[CONCEL=$c]">
                    <xsl:sort select="IDENTI"/>
                </xsl:apply-templates>
            </ul>
        </li>
    </xsl:template>

    <xsl:template match="ARQELEM" mode="subindice">
        <li>
            <a href="arq{count(preceding-sibling::*)+1}.html">
                <xsl:value-of select="IDENTI"/>
            </a>
        </li>
    </xsl:template>

    <xsl:template match="ARQELEM" mode="individual">
        <xsl:result-document  href="arqs/arq{count(preceding-sibling::*)+1}.html">
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
                    <address>[<a href="index.html">Voltar ao Indice</a>]</address>
                </body>
            </html>
        </xsl:result-document>
        <!-- <address>[<a href="#indice">Voltar ao Indice</a>]</address> -->
        <center><hr width="80%"/></center>
    </xsl:template>
</xsl:stylesheet>
