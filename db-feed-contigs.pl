#!/usr/bin/perl
use strict;
use warnings;
use DBI;

#-------------------------------------------------------------------------------
# USAGE & ARGUMENTS
#-------------------------------------------------------------------------------
while($#ARGV < 0){
	print <<"EOMAN";
 Usage:	$0 [-i] [-src_id]

 Arguments:
	-i input	Input file.
	-src_id Source ID.

 Example:
	> perl $0 input.fasta 50
EOMAN
	exit;
}


#-------------------------------------------------------------------------------
# ARGV set
#-------------------------------------------------------------------------------

my $input	= $ARGV[0];
my $src_id	= $ARGV[1];; #Source id:
my $type_base	= 1;  #1:DNA,  2:RNA, 3:AminiAcid
my $type_seq	= 5;  #1:GENE, 2:CDS, 3:MRNA, 4:PROTEIN, 5:CONTIG



#-------------------------------------------------------------------------------
# MySQL Connection
#-------------------------------------------------------------------------------
my $username = 'root';
my $password = '************';
my $database = 'NGS_AnnTools-v1';
my $hostname = 'localhost';

my $table    = 'seq_contig';

my $dbh = DBI->connect( "DBI:mysql:database=$database;host=$hostname;port=3306", $username, $password, {'RaiseError'=>1, 'mysql_enable_utf8'=>1} );
my $sql= "";

# Connection Test
#$success = $dbh->do($sql);
#if ($success) {
#	print "Success";
#} else {
#	print "Failure<br/>$DBI::errstr";
#}


#-------------------------------------------------------------------------------
# File Parser
#-------------------------------------------------------------------------------

	open (FILE_IN, $input) or die "File: '$input' not found!\n";

	my $count_ins = 0;
	my $count_err = 0;

	my $seq_name       = "";
	my $seq_fasta      = "";
	my $seq_length     = "";


	while(my $line = <FILE_IN>){

		chomp($line);

		if($line =~ />(.*)/){

			#Feed!
			if($seq_fasta ne ""){

				#DO: INSERT
				my $sql = "INSERT INTO $table  (`src_id`,  `tb_id`,      `ts_id`,     `ctg_name`,  `ctg_sequence`, `ctg_length`) VALUES
				                               ('$src_id', '$type_base', '$type_seq', '$seq_name', '$seq_fasta',   '$seq_length')";
				my $success = $dbh->do($sql);

				#my $success = 1;
				if ($success) {
					$count_ins++;
				} else {
					$count_err++;
					#print "Failure: $DBI::errstr\n";
					print "$sql\n\n";
				}

				#Print Status
				print "$count_ins: $seq_name  --> OK!\n";
			}

			#Reset!
			$seq_name       = "";
			$seq_fasta      = "";
			$seq_length     = 0;

			#New
			$seq_name       = $1;

			next;

		}else{

			$line =~ s/\s//g;
			$seq_fasta .= $line;
			$seq_length = length($seq_fasta);
		}

	}


	#Feed!
	if($seq_fasta ne ""){

		#DO: INSERT
		my $sql = "INSERT INTO $table(`src_id`,  `tb_id`,      `ts_id`,     `ctg_name`,  `ctg_sequence`, `ctg_length`) VALUES
									   ('$src_id', '$type_base', '$type_seq', '$seq_name', '$seq_fasta',   '$seq_length')";

		my $success = $dbh->do($sql);

		#my $success = 1;
		if ($success) {
			$count_ins++;
		} else {
			$count_err++;
			#print "Failure: $DBI::errstr\n";
			print "$sql\n\n";
		}

		#Print Status
		print "$count_ins: $seq_name  --> OK!\n";
	}

	close FILE_IN;

	print "OK!   Success: $count_ins, Error: $count_err\n";



# clean up
$dbh->disconnect();
