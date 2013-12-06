<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet zum Erzeugen von Notentabellen fuer die Kollegstufe -->

<!-- Copyright 2010, Alex Duesel, www.stylesheet-entwicklung.de/noten.html -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fo="http://www.w3.org/1999/XSL/Format"
        xmlns:html="http://www.w3.org/1999/xhtml">
       
        <xsl:output method="xml" indent="no"/>
       
        <xsl:template name="noten">
                <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-size="6pt">
                        <fo:layout-master-set>
                                <fo:simple-page-master master-name="my-page">
                                        <fo:region-body
                                                margin="5mm"
                                                column-gap="2mm"
                                                column-count="10"/>
                                        <fo:region-start extent="5mm"/>
                                        <fo:region-end extent="5mm"/>
                                </fo:simple-page-master>
                        </fo:layout-master-set>
                        <fo:page-sequence master-reference="my-page">
                                <fo:flow flow-name="xsl-region-body">
                                        <fo:block font-size="12pt" color="#999" font-weight="bold" span="all" text-align="center" line-height="20pt" letter-spacing="5mm">
                                                <xsl:text>German Grade Tables</xsl:text>
                                        </fo:block>
                                        <fo:block font-size="10pt" color="#999" span="all" text-align="center" line-height="30pt">
                                                <fo:basic-link external-destination="url('http://www.stylesheet-entwicklung.de/noten.html')" text-decoration="underline" color="blue">
                                                        <xsl:text>www.mandarine.tv</xsl:text>
                                                </fo:basic-link>
                                        </fo:block>
                                        <xsl:call-template name="noten-tabelle">
                                                <xsl:with-param name="von-punkte">12</xsl:with-param>
                                                <xsl:with-param name="bis-punkte">261</xsl:with-param>
                                        </xsl:call-template>
                                </fo:flow>
                        </fo:page-sequence>
                </fo:root>
        </xsl:template>
       
        <xsl:template name="note-runden">
                <xsl:param name="note"/>
                <xsl:variable name="rest" select="$note * 10 mod 10"/>
                <xsl:choose>
                        <xsl:when test="$rest &gt; 2.5">
                                <xsl:value-of select="floor(number($note))"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:value-of select="floor(number($note))-0.5"/>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
       
        <xsl:template name="noten-tabelle">
                <xsl:param name="von-punkte"/>
                <xsl:param name="bis-punkte"/>
                <xsl:if test="$von-punkte &lt; $bis-punkte+1">
                        <xsl:variable name="note6" select="$von-punkte div 3"/>
                        <xsl:variable name="note4" select="$von-punkte div 2"/>
                        <xsl:variable name="note5-schrittweite" select="($note4 +(-$note6)) div 3"/>
                        <xsl:variable name="schrittweite" select="$note4 div 12"/>
                        <xsl:variable name="note-6">
                                <xsl:call-template name="note-runden">
                                        <xsl:with-param name="note" select="$note6"/>
                                </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="note6-korrigiert">
                                <xsl:choose>
                                        <xsl:when test="3*($note-6+0.5) &lt; $von-punkte">
                                                <xsl:value-of select="$note6+0.5"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:value-of select="$note6"/>
                                        </xsl:otherwise>
                                </xsl:choose>                          
                        </xsl:variable>
                        <fo:block border="1pt solid grey" space-after="3pt" keep-together.within-column="always" padding="2pt">
                        <fo:block text-align="center" background-color="#999" color="white" padding-bottom="0pt" padding-top="2pt" space-after="2pt">
                                <xsl:text>Gesamt: </xsl:text>
                                <fo:inline  font-weight="bold">
                                        <xsl:value-of select="$von-punkte"/>
                                </fo:inline>
                        </fo:block>
                        <fo:block>
                                <fo:inline font-weight="bold">
                                        <xsl:text>0 P: </xsl:text>
                                </fo:inline>
                                <xsl:text>bis </xsl:text>
                                <xsl:call-template name="note-runden">
                                        <xsl:with-param name="note" select="$note6-korrigiert"/>
                                </xsl:call-template>
                        </fo:block>
                        <xsl:call-template name="note5">
                                <xsl:with-param name="i" select="0"/>
                                <xsl:with-param name="note6" select="$note6-korrigiert"/>
                                <xsl:with-param name="note5-schrittweite" select="$note5-schrittweite"/>
                                <xsl:with-param name="gesamt" select="$von-punkte"/>
                        </xsl:call-template>
                        <xsl:call-template name="ab-note4">
                                <xsl:with-param name="i" select="0"/>
                                <xsl:with-param name="note4" select="$note4"/>
                                <xsl:with-param name="schrittweite" select="$schrittweite"/>
                        </xsl:call-template>
                        <fo:block/>
                        <fo:block/>
                        </fo:block>
                        <xsl:call-template name="noten-tabelle">
                                <xsl:with-param name="von-punkte" select="$von-punkte+1"/>
                                <xsl:with-param name="bis-punkte" select="$bis-punkte"/>
                        </xsl:call-template>
                </xsl:if>
        </xsl:template>
       
        <xsl:template name="note5">
                <xsl:param name="i"/>
                <xsl:param name="note6"/>
                <xsl:param name="note5-schrittweite"/>
                <xsl:param name="gesamt"/>
                <xsl:if test="$i &lt; 3">
                        <xsl:variable name="note-von-gerundet">
                                <xsl:call-template name="note-runden">
                                        <xsl:with-param name="note" select="number($note6) + number($i)*number($note5-schrittweite)"/>
                                </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="von" select="$note-von-gerundet+0.5"/>
                        <xsl:variable name="bis">
                                <xsl:call-template name="note-runden">
                                        <xsl:with-param name="note" select="number($note6)+(number($i)+1)*number($note5-schrittweite)"/>
                                </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="bis-korrigiert">
                                <xsl:choose>
                                        <xsl:when test="$i=2 and (2*$bis)=number($gesamt)">
                                                <xsl:value-of select="$bis+(-0.5)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:value-of select="$bis"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:variable>
                        <fo:block>
                                <fo:inline font-weight="bold">
                                        <xsl:value-of select="$i+1"/>
                                        <xsl:text> P: </xsl:text>
                                </fo:inline>
                                <xsl:value-of select="$von"/>
                                <xsl:text> - </xsl:text>
                                <xsl:value-of select="$bis-korrigiert"/>
                        </fo:block>
                        <xsl:call-template name="note5">
                                <xsl:with-param name="i" select="$i+1"/>
                                <xsl:with-param name="note6" select="$note6"/>
                                <xsl:with-param name="note5-schrittweite" select="$note5-schrittweite"/>
                                <xsl:with-param name="gesamt" select="$gesamt"/>
                        </xsl:call-template>
                </xsl:if>
        </xsl:template>
       
        <xsl:template name="ab-note4">
                <xsl:param name="i"/>
                <xsl:param name="note4"/>
                <xsl:param name="schrittweite"/>
                <xsl:if test="$i &lt; 12">
                        <xsl:variable name="note-von-gerundet">
                                <xsl:call-template name="note-runden">
                                        <xsl:with-param name="note" select="number($note4) + number($i)*number($schrittweite)"/>
                                </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="von" select="$note-von-gerundet+0.5"/>
                        <xsl:variable name="bis">
                                <xsl:call-template name="note-runden">
                                        <xsl:with-param name="note" select="number($note4)+(number($i)+1)*number($schrittweite)"/>
                                </xsl:call-template>
                        </xsl:variable>
                        <fo:block>
                                <fo:inline font-weight="bold">
                                        <xsl:value-of select="$i+4"/>
                                        <xsl:text> P: </xsl:text>
                                </fo:inline>
                                <xsl:value-of select="$von"/>
                                <xsl:text> - </xsl:text>
                                <xsl:value-of select="if ($i=11) then ($bis+0.5) else $bis"/>
                        </fo:block>
                        <xsl:call-template name="ab-note4">
                                <xsl:with-param name="i" select="$i+1"/>
                                <xsl:with-param name="note4" select="$note4"/>
                                <xsl:with-param name="schrittweite" select="$schrittweite"/>
                        </xsl:call-template>
                </xsl:if>
        </xsl:template>
</xsl:stylesheet>