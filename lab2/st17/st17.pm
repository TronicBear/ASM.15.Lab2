package ST17;
use strict;
use CGI;
use Data::Dump qw(dump);

sub st17
{

	my %file;
	my ($q, $global) = @_;

	print $q->header(
		-type=>"text/html",
		-charset=>"windows-1251"
	);
	
	print '<a href="'.$global->{selfurl}.'">����� � ������</a><br><br>';

	

	my %commands = (
		'update' => sub {
			$file{$q->param('id')} = join('-%%-',$q->param('name'), $q->param('author'));
		},
		'delete' => sub {
			delete $file{$q->param('id')};
		},
		'add' => sub {
			my $new_id = -1;
			for (keys %file) 
			{
				$new_id = $_ if $new_id < $_;
			}
			$file{$new_id + 1} = join('-%%-',$q->param('name'), $q->param('author'))
		}
	);

	
	dbmopen(%file, "song_db", 0644);
	my $command = $q->param('action');
	if (defined $commands{$command}) 
	{
		$commands{$command}->();	
	}

	my $id = $q->param('id');
	my $action = "add";
	my $title = "�������� ����� ����� � ��������";
	my $name = "";
	my $author = "";
	if($q->param('action') eq 'goto_update') 
	{
		($name, $author) = split(/-%%-/, $file{$id});
		$action = "update";
		$title = "������������� ������ � �����";
	}
	print "<form method=\"post\">
	  	<input type=\"hidden\" name=\"student\" value=\"".$global->{student}."\">
	  	<input type=\"hidden\" name=\"id\" value=\"$id\">
	  	<table>
	  		<tr><th colspan = 2>$title</th></tr>
	  		<tr>
	  			<td>�������� �����:</td>
	  			<td><input type=\"text\" name=\"name\" value=\"$name\"></td>
	  		</tr>
	  		<tr>
	  			<td>��� ������:</td>
	  			<td><input type=\"text\" name=\"author\"  value=\"$author\"></td>
	  		</tr>
	  		<tr><td colspan = 2 align = right>
	  			<button name=\"action\" type=\"submit\" value=\"$action\">���������</button></td>
	  		</tr>
	  	</table>	  	
 	</form><br><br>";
	
	print "<table>
			<tr><th colspan = 4>��������</th></tr>
			<tr align = center>
				<td><b>�</b></td>
				<td><b>�������� �����</b></td>
		 		<td><b>�����</b></td>
		 		<td colspan = 2><b>��������</b></td>
			</tr>";
	my $i = 1;
	while ( my ($key, $value) = each %file )
	{
		my ($name, $author) = split(/-%%-/, $value);
		print "<tr>
			<form method=\"post\">
				<input type=\"hidden\" name=\"student\" value=\"".$global->{student}."\">
				<input type=\"hidden\" name=\"id\" value=\"$key\">
				<td>$i</td>
		  		<td>$name</td>
		  		<td>$author</td>
		  		<td>
		  			<button name=\"action\" type=\"submit\" value=\"goto_update\">��������</button>
		  		</td>
		  		<td>
		  			<button name=\"action\" type=\"submit\" value=\"delete\">�������</button>
		  		</td>
		 	</form>
		</tr>";
		$i++;
	}
	print "</table><br>";
	
	dbmclose(%file);
}

1;