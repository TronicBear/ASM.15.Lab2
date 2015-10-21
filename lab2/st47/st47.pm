#!perl.exe

package ST47;
use strict;
use CGI;
use Scalar::Util qw(looks_like_number);

sub st47 {
	my ($page, $global) = @_;

	my @MainList = ();

	sub add {
		my $cname = $page->param('cname');	
		my $ctown = $page->param('ctown');
		if ( ( $cname ne "" ) && ( $ctown ne "") ){
			my $file = ("database");	
			my %h;
			dbmopen(%h, $file, 0644);
			my $size = scalar keys %h;
			$h{$size} = join('--', $cname, $ctown);		
			dbmclose(%h);
		}
	};
	sub edit {
		my $cname = $page->param('cname');	
		my $ctown = $page->param('ctown');
		my $number = $page->param('number');
		if ( ( $cname ne "" ) && ( $ctown ne "") ){
			my $file = ("database");	
			my %h;
			dbmopen(%h, $file, 0644);
			$h{$number} = join('--', $cname, $ctown);
			dbmclose(%h);
		}	
	}
	sub delete {
		my $number = $page->param('number');
		my $file = ("database");	
		my %h;
		dbmopen(%h, $file, 0644);
		my @RedactList = ();
		for (my $i = 0; ; $i++){
			if (exists $h{$i}){
				if ($i != $number){
					push @RedactList, $h{$i};
				}
			} else {
				last;
			}		
		}
		undef %h;
		for (my $i = 0;  $i < scalar @RedactList; $i++){
			$h{$i} = $RedactList[$i];
		}	
		dbmclose(%h);
	}
	my @functions = (
		\&add,
		\&edit,
		\&delete
	);

	if (looks_like_number($page->param('action'))){
		$functions[$page->param('action')]();
	}

	sub load {
		my $file = ( "database" );	
		my %h;
		dbmopen(%h, $file, 0644);
		for (my $i = 0; ; $i++){
			if (exists $h{$i}){
				my ($cname, $ctown) = split(/--/, $h{$i});
				push @MainList, {cname => $cname, ctown => $ctown};
			} else {
				last;
			}		
		}
		dbmclose(%h);
	};
	sub show_page {
		print '
			<table width="100%" border=0>
				<tr>
					<td colspan=5 style="font-size:30px; text-align: center;">
						������ ��������
					</td>
				</tr>
			<tr>
				<td  style="font-size:16px; text-align: center;">
					<b>
					�
					</b>
				</td>
				<td  style="font-size:16px; text-align: center;">
					<b>
						�������� ��������
					</b>
				</td>
				<td  style="font-size:16px; text-align: center;">
					<b>
						�����
					</b>
				</td>
				<td  colspan=2 style="font-size:16px; text-align: center;">
					<b>
						��������
					</b>
				</td>
			</tr>';	
		print $page->start_form();
		print '
			<tr>
				<td  style="font-size:16px; text-align: center;">
					<b>';
		print $page->hidden('student',$global->{'student'});
		print '			</b>
				</td>
				<td  style="font-size:16px; text-align: center;">
					<b>';
		print $page->textfield('�name',"",30,100);
		print '
					</b>
				</td>
				<td  style="font-size:16px; text-align: center;">
					<b>';
		print $page->textfield('�town',"",30,100);		
		print '
					</b>
				</td>
				<td  colspan=2 style="font-size:16px; text-align: center;">
					<b>
					<button name="action" value=0 type="submit">��������</button>
					</b>
				</td>
			</tr>';	
		print $page->end_form;		
		if (scalar @MainList == 0){
			print '<tr>
					<td colspan=5 style="font-size:24px; text-align: center;">
						<b>������ ����</b>
					</td>
				</tr>';	
		} else {
			for (my $i = 0; $i < scalar @MainList; $i++) {
				print $page->start_form();
				print '
					<tr>
						<td  style="font-size:16px; text-align: center;">
							<b>';
				print $page->hidden('number',$i);
				print $page->hidden('student',$global->{'student'});
				print $i+1;
				print '
							</b>
						</td>
						<td  style="font-size:16px; text-align: center;">
							<b>';
				print $page->textfield('�name',$MainList[$i]->{'ctown'},30,100);
				print '
							</b>
						</td>
						<td  style="font-size:16px; text-align: center;">
							<b>';
				print $page->textfield('ctown',$MainList[$i]->{'ctown'},30,100);		
				print '
							</b>
						</td>
						<td  style="font-size:16px; text-align: center;">
							<b>
							<button name="action" value=1 type="submit">�������������</button>
							</b>
						</td>
						<td  style="font-size:16px; text-align: center;">
							<b>
							<button name="action" value=2 type="submit">�������</button>
							</b>
						</td>
					</tr>';	
				print $page->end_form;
			}	
		}
		print '
			</table>
			<a href="'.$global->{'selfurl'}.'"><<�����</button>';		
	}

	print $page->header( -type => "text/html", -charset => "windows-1251");
	print $page->start_html( -title => "������ �.�." );
	print $page->delete_all();
	load;
	show_page;
	print $page->end_html;
}

return 1;
