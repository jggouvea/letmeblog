cd templates
cat head1.tpl head2.tpl head3.tpl head4.tpl head5.tpl head6.tpl > blog.html
echo "<div id=\"sidebar\">" >> blog.html
cat sbar.txt >> blog.html
echo "</div>" >> blog.html
cat body.tpl >> blog.html
echo "<div id=\"footer\">" >> blog.html
cat foot.txt >> blog.html
echo "</div>
</body></html>" >> blog.html
cd ..
