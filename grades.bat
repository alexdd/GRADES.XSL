java -jar lib\saxon\saxon8.jar -it noten grades.xsl >grades.fo
lib\fop-1.0\fop grades.fo -pdf grades.pdf