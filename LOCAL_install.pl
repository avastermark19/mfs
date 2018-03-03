#! /usr/bin/perl -w
use strict;

` cp ~/mfs/Pfam-A* . `;
` cp ~/mfs/uniprot* . `;
` cp ~/mfs/topcons* . `;
` cp ~/mfs/TMalign* . `;

` chmod u+x *.pl `;
` chmod u+x *.exe `;
` chmod u+x TMalign `;

if ( -e "../../mfs/BACKUP_MFS" ) {
` mkdir BACKUP `;
` cp -r ../../mfs/BACKUP_MFS/* BACKUP/ `;
}

exit;

