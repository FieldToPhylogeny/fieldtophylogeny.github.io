<img src="images/Field2Phylogeny-logo.png" alt="Field2Phylogeny" width="600">

# Identifying sequences with BLAST and BOLD

## Sequence contig
From our last session, you shoild have aligned your forward and reverse raw sequences into a single, **contiguous sequence** (a "contig"). Now we can ask *Which known sequences look most like yours?*

You will search your contig against **NCBI GenBank** (with **BLAST**) and **BOLD**, then download the closest sequences for the next module (alignment). 

**Your sequence:** your contig from Module 1, or the backup file for your group: [Mystery-A-contig.fasta](data/Mystery-A-contig.fasta) · [Mystery-B-contig.fasta](data/Mystery-B-contig.fasta). Open FASTA files in **Notepad++** or **BBEdit**, never in Word.

| | **BLAST** (GenBank) | **BOLD** |
|---|---|---|
| Contains | Almost every published sequence, any gene | Barcode genes (COI), each linked to a specimen |
| Watch out | Names are not checked | Fewer sequences for many Malagasy groups |

> **BIN (Barcode Index Number):** a cluster of very similar COI sequences in BOLD. 

## Exercise 1: BLAST

1. Go to [blast.ncbi.nlm.nih.gov](https://blast.ncbi.nlm.nih.gov/Blast.cgi) → **Nucleotide BLAST**.
2. Paste your whole FASTA (with the `>` line).
3. Database: **Core nucleotide (core_nt)**. Program: **megablast**. Click **BLAST**.

![BLAST settings](images/blast-02-settings.png)

In the results, check three columns:

| Column | Look for |
|---|---|
| **Query Cover** | close to 100% |
| **Per. Ident** | 99–100% same species · 95–98% check carefully · below 94% probably a different species |
| **E value** | close to 0 |

Then ask: do the top 5–10 hits agree? Is the top hit a Malagasy animal from the group you expected?

## Exercise 2: BOLD

1. Go to [id.boldsystems.org](https://id.boldsystems.org/) and paste your sequence.
2. Database: **Animal Library (Public)**. Mode: **Genus and Species Search**. Click **Submit**.
3. Note the top **similarity (%)**, **name** and **BIN**. Click the BIN to see where its specimens were collected.

| | BLAST | BOLD |
|---|---|---|
| Top match | | |
| % identity | | |
| Accession / BIN | | |
| Do they agree? | | |


## Exercise 3: Download and clean the sequences

1. In BLAST **Descriptions**, tick 10–20 close hits (several species) and 2–3 from another genus (outgroup).
2. **Download → FASTA (aligned sequences)**. *Not* "complete sequence": that can download a 16,000-base genome.
3. Rename each sequence `Genus_species_Accession` (no spaces or symbols). In Notepad++ use Find/Replace with *Regular expression*:

| Find | Replace |
|---|---|
| `^>([^.\s]+)\S*\s+(\S+)\s+(\S+).*$` | `>\2_\3_\1` |

4. Add your own contig (e.g. `>MYSTERY_A`). Check no two names are the same.
5. Save as `GroupA_COI_unaligned.fasta`.

```
>MYSTERY_A
AAGATATTGGAACCCTATACC...
>Compsophis_boulengeri_MN123456
AAGATATTGGAACCCTATACC...
```

## Questions

1. What was your top BLAST match (query cover, % identity)? Did BOLD agree?
2. Can you call a sample a new species if the best match is 92%? What else would you need?

### Record your analysis

> For publication: *Sequences were compared with NCBI BLASTn (megablast, core_nt; accessed [date]) and the BOLD Identification Engine (Animal Library, Genus and Species Search). 


### Continue the workshop

* Previous: [Module 1: Sequence editing](Module1-sequence-editing-lab.md)
* Next: [Module 3: Sequence alignment](Module3-sequence-alignment.md)
* [Madagascar 2026 workshop home](https://fieldtophylogeny.github.io/Madagascar2026/)
