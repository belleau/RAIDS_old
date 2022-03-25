#' @title This function initialise the sample information in the gds file.
#' The information is extract from data.frame pedDF
#'
#' @description TODO
#'
#' @param gds a \code{gds}.
#'
#' @param pedDF a \code{data.frame} with the sample info. Must have the column
#' sample.id, Name.ID, sex, pop.group, superPop and batch. The unique id of pedDF
#' is Name.ID and the row.name is Name.ID too.
#'
#' @param listSamples a \code{array} with the sample from pedDF to keep
#'
#' @return the a \code{array} with the sample from pedDF keept
#'
#' @examples
#'
#' # TODO
#'
#' @author Pascal Belleau, Astrid Desch&ecirc;nes and Alex Krasnitz
#' @importFrom gdsfmt add.gdsn
#' @keywords internal


generateGDSSample <- function(gds, pedDF, listSamples = NULL){

    if(!(is.null(listSamples))){
        pedDF <- pedDF[listSamples,]
    }
    add.gdsn(gds, "sample.id", pedDF[, "Name.ID"])

    samp.annot <- data.frame(sex = pedDF[, "sex"],
                             pop.group = pedDF[, "pop.group"],
                             superPop = pedDF[, "superPop"],
                             batch=pedDF[, "batch"],
                             stringsAsFactors = FALSE)


    add.gdsn(gds, "sample.annot", samp.annot)

    return(pedDF[, "sample.id"])

}

#' @title The function add an array sample.ref to the gds file.It define base
#' on a list of unrelated samples.
#'
#' @description This function create the field sample.ref which is 1 when the sample
#' are a reference and 0 otherwise. The sample.ref is fill base of on the file filePart$unrels
#' from  in GENESIS TODO
#'
#' @param gds a \code{gds} object.
#'
#' @param filePart a \code{list} from the function pcairPartition in GENESIS
#'
#' @return NULL
#'
#' @examples
#'
#' # TODO
#'
#' @author Pascal Belleau, Astrid Desch&ecirc;nes and Alex Krasnitz
#' @importFrom gdsfmt add.gdsn
#' @keywords internal


addGDSRef <- function(gds, filePart){

    part <- readRDS( filePart)


    sampleGDS <- index.gdsn(gds, "sample.id")
    df <- data.frame(sample.id = read.gdsn(sampleGDS),
                     sample.ref = 0,
                     stringsAsFactors = FALSE)

    df[df$sample.id %in% part$unrels, "sample.ref"] <- 1
    add.gdsn(gds, "sample.ref", df$sample.ref, storage = "bit1")

}


#' @title This function append the fields related to the samples. If the
#' samples are part of a study you must uses the addStudyGDSSample
#'
#' @description This function append the fields related to the samples. The fields
#' append are sample.id and the \code{data.frame} sample.annot. If the samples
#' are in the section study the field related to the study must be fill.
#'
#' @param gds a \code{gds}.
#'
#' @param pedDF a \code{data.frame} with the sample info. Must have the column
#' sample.id, Name.ID, sex, pop.group, superPop and batch. The unique id of pedDF
#' is Name.ID and the row.name is Name.ID too.
#'
#' @param listSamples a \code{array} with the sample from pedDF$Name.ID to keep
#'
#'
#' @return NULL
#'
#' @examples
#'
#' # TODO
#'
#' @author Pascal Belleau, Astrid Desch&ecirc;nes and Alex Krasnitz
#' @importFrom gdsfmt index.gdsn append.gdsn
#' @keywords internal


appendGDSSample <- function(gds, pedDF, batch=1, listSamples = NULL){

    if(!(is.null(listSamples))){
        pedDF <- pedDF[listSamples,]
    }

    sampleGDS <- index.gdsn(gds, "sample.id")

    append.gdsn(sampleGDS,  val=pedDF$Name.ID, check=TRUE)


    samp.annot <- data.frame(sex = pedDF[, "sex"],
                             pop.group = pedDF[, "pop.group"],
                             superPop = pedDF[, "superPop"],
                             batch=rep(batch,nrow(pedDF)),
                             stringsAsFactors = FALSE)

    print("Annot")
    curAnnot <- index.gdsn(gds, "sample.annot/sex")
    append.gdsn(curAnnot,samp.annot$sex, check=TRUE)
    curAnnot <- index.gdsn(gds, "sample.annot/pop.group")
    append.gdsn(curAnnot, samp.annot$pop.group, check=TRUE)
    curAnnot <- index.gdsn(gds, "sample.annot/superPop")
    append.gdsn(curAnnot, samp.annot$superPop, check=TRUE)
    curAnnot <- index.gdsn(gds, "sample.annot/batch")
    append.gdsn(curAnnot, samp.annot$batch, check=TRUE)
    print("Annot done")

}

#' @title This function create the gds file fields related to the study and the sample in it.
#'
#' @description TODO
#'
#' @param gds a \code{gds} object.
#'
#' @param pedDF a \code{data.frame} with the sample info. Must have the column
#' sample.id, Name.ID, sex, pop.group, superPop and batch. The unique id of pedDF
#' is Name.ID and the row.name is Name.ID too.
#'
#' @param batch a \code{integer} corresponding
#'
#' @param listSamples a \code{array} with the sample from pedDF to keep
#'
#' @param studyDF a \code{data.frame} with at least the column study.id,
#' study.desc and study.platform
#'
#' @return NULL
#'
#' @examples
#'
#' # TODO
#'
#' @author Pascal Belleau, Astrid Desch&ecirc;nes and Alex Krasnitz
#' @importFrom gdsfmt index.gdsn append.gdsn
#' @keywords internal


addStudyGDSSample <- function(gds, pedDF, batch=1, listSamples = NULL, studyDF){

    if(c("study.id", "study.desc", "study.platform") %in% colnames(studyDF) ){
        stop(paste0("studyDF incomplete in addStudyGDSSample\n"))
    }

    if(!(is.null(listSamples))){
        pedDF <- pedDF[listSamples,]
    } else{
        listSamples <- pedDF$Name.ID
    }

    sampleGDS <- index.gdsn(gds, "sample.id")

    samplePres <- read.gdsn(sampleGDS)
    print(paste0("appendGDSSample ", Sys.time()))
    appendGDSSample(gds, pedDF, batch=batch, listSamples = listSamples)
    print(paste0("appendGDSSample DONE ", Sys.time()))

    add.gdsn(gds, "study.offset", length(samplePres))

    df <- data.frame(study.id = studyDF$study.id,
                     study.desc = studyDF$study.desc,
                     study.platform = studyDF$study.platform,
                     stringsAsFactors = FALSE)


    add.gdsn(gds, "study.list", df)


    study.annot <- data.frame(data.id = pedDF[, "sample.id"],
                              case.id = pedDF[, "Case.ID"],
                              sample.type = pedDF[, "Sample.Type"],
                              diagnosis = pedDF[, "Diagnosis"],
                              source = pedDF[, "Source"],
                              study.id = rep(study.id, nrow(pedDF)),
                              stringsAsFactors = FALSE)

    add.gdsn(gds, "study.annot", study.annot)
    print(paste0("study.annot DONE ", Sys.time()))
    return(pedDF[,"Name.ID"])

}


#' @title This function create the fields related to the snp
#'
#' @description TODO
#'
#' @param gds a \code{gds} object.
#'
#' @param fileFREQ string with the path and the fileNames to a files with
#' frequence information TODO describe the file
#'
#'
#' @return NULL
#'
#' @examples
#'
#' # TODO
#'
#' @author Pascal Belleau, Astrid Desch&ecirc;nes and Alex Krasnitz
#' @importFrom gdsfmt add.gdsn
#' @keywords internal


generateGDSSNPinfo <- function(gds, fileFREQ){

    mapSNVSel <- readRDS( fileFREQ)
    print(paste0("Read mapSNVSel DONE ", Sys.time()))

    add.gdsn(gds, "snp.id", paste0("s",seq_len(nrow(mapSNVSel))))
    print(paste0("SNP part snp.id DONE ", Sys.time()))
    add.gdsn(gds, "snp.chromosome", as.integer(gsub("chr", "", mapSNVSel$CHROM)), storage = "uint16")
    print(paste0("SNP part snp.chromosome DONE ", Sys.time()))
    add.gdsn(gds, "snp.position", as.integer(mapSNVSel$POS), storage = "int32")
    print(paste0("SNP part snp.position DONE ", Sys.time()))
    add.gdsn(gds, "snp.allele", paste0(mapSNVSel$REF, "/", mapSNVSel$ALT))
    print(paste0("SNP part 1 DONE ", Sys.time()))
    add.gdsn(gds, "snp.AF", as.numeric(mapSNVSel$AF), storage = "packedreal24")
    print(paste0("SNP part AF DONE ", Sys.time()))
    add.gdsn(gds, "snp.EAS_AF", as.numeric(mapSNVSel$EAS_AF), storage = "packedreal24")
    add.gdsn(gds, "snp.EUR_AF", as.numeric(mapSNVSel$EUR_AF), storage = "packedreal24")
    add.gdsn(gds, "snp.AFR_AF", as.numeric(mapSNVSel$AFR_AF), storage = "packedreal24")
    add.gdsn(gds, "snp.AMR_AF", as.numeric(mapSNVSel$AMR_AF), storage = "packedreal24")
    add.gdsn(gds, "snp.SAS_AF", as.numeric(mapSNVSel$SAS_AF), storage = "packedreal24")

}



#' @title This function create the field genotype in the gds file
#'
#' @description TODO
#'
#' @param gds a \code{gds} object.
#'
#' @param PATHGENO TODO a PATH to a directory with the a file for each samples with the genotype.
#'
#' @param fileLSNP TODO list of SNP to keep in the file genotype
#'
#' @param listSamples  a \code{array} with the sample to keep
#'
#'
#'
#' @return NULL
#'
#' @examples
#'
#' # TODO
#'
#' @author Pascal Belleau, Astrid Desch&ecirc;nes and Alex Krasnitz
#' @importFrom gdsfmt add.gdsn write.gdsn
#' @keywords internal


generateGDSgenotype <- function(gds, PATHGENO, fileLSNP, listSamples){

    # File with the description of the SNP keep
    listMat1k <- dir(PATHGENO, pattern = ".+.csv.bz2")
    listSample1k <- gsub(".csv.bz2", "", listMat1k)

    listSNP <- readRDS(fileLSNP)

    for(i in seq_len(length(listSamples))){
        pos <- which(listSample1k == listSamples[i])
        print(listSamples[i])
        if( length(pos) == 1){
            matSample <- read.csv2( file.path(PATHGENO, listMat1k[pos]),
                                    row.names = NULL)
            matSample <- matSample[listSNP,, drop=FALSE]
            if(i == 1){
                var.geno <- add.gdsn(gds, "genotype",
                                     valdim=c( nrow(matSample), length(listSamples)), storage="bit2")
            }

            # Not faster but harder to read
            # matSample[,1] <- rowSums(t(matrix(as.numeric(unlist(strsplit( matSample[,1], "\\|"))),nr=2)))
            # Easier to read
            matSample[matSample[,1] == "0|0",1] <- 0
            matSample[matSample[,1] == "0|1" | matSample[,1] == "1|0",1] <- 1
            matSample[matSample[,1] == "1|1",1] <- 2

            g <- as.matrix(matSample)[,1]
            write.gdsn(var.geno, g, start=c(1, i), count=c(-1,1))
            rm(matSample)
            print(paste0(listMat1k[pos], " ", i))
        }else{
            stop(paste0("Missing samples genotype in ", listSamples[i]))
        }
    }
}

#' @title This function append the field genotype in the gds file
#'
#' @description TODO
#'
#' @param gds a \code{gds} object.
#'
#' @param PATHGENO TODO a PATH to a directory with the a file for each samples with the genotype.
#'
#' @param fileLSNP TODO list of SNP to keep in the file genotype
#'
#' @param listSamples  a \code{array} with the sample to keep
#'
#'
#' @return NULL
#'
#' @examples
#'
#' # TODO
#'
#' @author Pascal Belleau, Astrid Desch&ecirc;nes and Alex Krasnitz
#' @importFrom gdsfmt index.gdsn read.gdsn
#' @keywords internal


appendGDSgenotype <- function(gds, listSample, PATHGENO, fileLSNP ){

    # File with the description of the SNP keep
    listMat1k <- dir(PATHGENO, pattern = ".+.csv.bz2")
    listSample1k <- gsub(".csv.bz2", "", listMat1k)

    listSNP <- readRDS(fileLSNP)
    geno.var <- index.gdsn(gds, "genotype")
    g <- read.gdsn(geno.var, start=c(1, 1), count=c(1,-1))
    nbSample <- length(g)
    print(nbSample)
    for(i in seq_len(length(listSample))){
        pos <- which(listSample1k == listSample[i])
        if( length(pos) == 1){
            matSample <- read.csv2( file.path(PATH1KG, "data", "sampleGeno", listMat1k[pos]),
                                    row.names = NULL)
            matSample <- matSample[listSNP,, drop=FALSE]


            # Not faster but harder to read
            # matSample[,1] <- rowSums(t(matrix(as.numeric(unlist(strsplit( matSample[,1], "\\|"))),nr=2)))
            # Easier to read
            matSample[matSample[,1] == "0|0",1] <- 0
            matSample[matSample[,1] == "0|1" | matSample[,1] == "1|0",1] <- 1
            matSample[matSample[,1] == "1|1",1] <- 2

            g <- as.matrix(matSample)[,1]
            append.gdsn(geno.var,g, check=TRUE)

            rm(matSample)
            print(paste0(listMat1k[pos], " ", i))
        }else{
            stop(paste0("Missing 1k samples ", listSample[i]))
        }
    }
}

#' @title TODO This function append the genotype and the file related to the pileup
#'
#' @description TODO
#'
#' @param gds a \code{gds} object.
#'
#' @param PATHGENO TODO a PATH to a directory with the a file for each samples with the genotype.
#'
#' @param listSamples  a \code{array} with the sample to keep
#'
#' @param listPos  a \code{array}
#'
#' @param offset  a \code{integer} to adjust if the genome start at 0 or 1
#'
#' @param minCov  a \code{array} with the sample to keep
#'
#' @param minProb  a \code{array} with the sample to keep
#'
#' @param seqError  a \code{array} with the sample to keep
#'
#'
#' @return NULL
#'
#' @examples
#'
#' # TODO
#'
#' @author Pascal Belleau, Astrid Desch&ecirc;nes and Alex Krasnitz
#' @importFrom gdsfmt add.gdsn write.gdsn
#' @keywords internal


generateGDS1KGgenotypeFromSNPPileup <- function(gds, PATHGENO,
                                                listSamples,listPos, offset,
                                                minCov = 10, minProb = 0.999, seqError = 0.001){



    # File with the description of the SNP keep
    listMat <- dir(PATHGENO, pattern = ".+.txt.gz")
    listSampleFile <- gsub(".txt.gz", "", listMat)


    g <- as.matrix(rep(-1, nrow(listPos)))

    for(i in seq_len(length(listSamples))){
        pos <- which(listSampleFile == listSamples[i])
        print(paste0(listSamples[i], " ", Sys.time()))
        if( length(pos) == 1){

            matSample <- read.csv(file.path(PATHGENO, listMat[pos]))


            matSample[, "Chromosome"] <- as.integer(gsub("chr", "", matSample[, "Chromosome"]))
            matSample[, "Position"] <- matSample[, "Position"] + offset
            matSample[, "count"] <- rowSums(matSample[, c("File1R", "File1A", "File1E", "File1D")])

            # matAll <- merge(matSample[,c( "Chromosome", "Position",
            #                               "File1R",  "File1A",
            #                               "count" )],
            #                 listPos,
            #                 by.x = c("Chromosome", "Position"),
            #                 by.y = c("snp.chromosome", "snp.position"),
            #                 all.y = TRUE,
            #                 all.x = FALSE)
            #
            # below same as the merge above but faster

            z <- cbind(c(listPos$snp.chromosome,
                         matSample$Chromosome,
                         matSample$Chromosome),
                       c(listPos$snp.position,
                         matSample$Position,
                         matSample$Position),
                       c(rep(1,nrow(listPos)),
                         rep(0,nrow(matSample)),
                         rep(2,nrow(matSample))),
                       c(rep(0,nrow(listPos)),
                         matSample[, "File1R"],
                         -1 * matSample[, "File1R"]),
                       c(rep(0,nrow(listPos)),
                         matSample[, "File1A"],
                         -1 * matSample[, "File1A"]),
                       c(rep(0,nrow(listPos)),
                         matSample[, "count"],
                         -1 * matSample[, "count"]))
            rm(matSample)
            z <- z[order(z[,1], z[,2], z[,3]),]

            matAll <- data.frame(Chromosome = z[z[,3]==1, 1],
                                 Position = z[z[,3]==1, 2],
                                 File1R = cumsum(z[,4])[z[,3]==1],
                                 File1A = cumsum(z[,5])[z[,3]==1],
                                 count = cumsum(z[,6])[z[,3]==1])
            rm(z)
            if(i == 1){
                var.geno <- index.gdsn(gds, "genotype")

                var.Ref <- add.gdsn(gds, "Ref.count",
                                    matAll$File1R,
                                    valdim=c( nrow(listPos), 1), storage="sp.int16")
                var.Alt <- add.gdsn(gds, "Alt.count",
                                    matAll$File1A,
                                    valdim=c( nrow(listPos), 1), storage="sp.int16")
                var.Count <- add.gdsn(gds, "Total.count",
                                      matAll$count,
                                      valdim=c( nrow(listPos), 1), storage="sp.int16")

            } else{

                append.gdsn(var.Ref,matAll$File1R)
                append.gdsn(var.Alt, matAll$File1A)
                append.gdsn(var.Count, matAll$count)
            }

            listCount <- table(matAll$count[matAll$count >= minCov])
            cutOffA <- data.frame(count = unlist(vapply(as.integer(names(listCount)),
                                                        FUN=function(x, minProb, eProb){return(max(2,qbinom(minProb, x,eProb)))},
                                                        FUN.VALUE = numeric(1), minProb=minProb, eProb= 2 * seqError )),
                                  allele = unlist(vapply(as.integer(names(listCount)),
                                                         FUN=function(x, minProb, eProb){return(max(2,qbinom(minProb, x,eProb)))},
                                                         FUN.VALUE = numeric(1), minProb=minProb, eProb=seqError)))
            row.names(cutOffA) <- names(listCount)
            # Initialize the genotype array at -1


            # Select the position where the coverage of the 2 alleles is enough
            listCov <- which(rowSums(matAll[, c("File1R", "File1A")]) >= minCov)


            matAllC <- matAll[listCov,]

            # The difference  depth - (nb Ref + nb Alt) can be realisticly explain by sequencing error
            listCov <- listCov[(matAllC$count -
                                    (matAllC$File1R +
                                         matAllC$File1A)) < cutOffA[as.character(matAllC$count), "count"]]

            matAllC <- matAll[listCov,]
            rm(matAll)
            g <- as.matrix(rep(-1, nrow(listPos)))
            # The sample is homozygote if the other known allele have a coverage of 0
            g[listCov][which(matAllC$File1A == 0)] <- 0
            g[listCov][which(matAllC$File1R == 0)] <- 2

            # The sample is heterozygote if explain the coverage of the minor allele by
            # sequencing error is not realistic.
            g[listCov][which(matAllC$File1A >= cutOffA[as.character(matAllC$count), "allele"] &
                                 matAllC$File1R >= cutOffA[as.character(matAllC$count), "allele"])] <- 1

            #g <- as.matrix(g)
            append.gdsn(var.geno, g)
            rm(g)
            print(paste0(listMat[pos], " ", i, " ", Sys.time()))
        }else{
            stop(paste0("Missing samples ", listSamples[i]))
        }
    }
}



#' @title create a file tfam file for plink from the gds file
#'
#' @description TODO
#'
#' @param gds a \code{gds} object.
#'
#' @param listSamples  a \code{array} with the sample to keep
#'
#' @param pedOUT TODO a PATH and file name to the output file
#'
#'
#' @return TODO a \code{vector} of \code{numeric}
#'
#' @examples
#'
#' # TODO
#'
#' @author Pascal Belleau, Astrid Desch&ecirc;nes and Alex Krasnitz
#' @importFrom gdsfmt index.gdsn read.gdsn
#' @keywords internal

gds2tfam <- function(gds, listSample, pedOUT){

    sampleGDS <- index.gdsn(gds, "sample.id")
    sampleId <-read.gdsn(sampleGDS)
    listS <- which(sampleId %in% listSample)

    sampleGDS <- index.gdsn(gds, "sample.annot")
    sampleANNO <-read.gdsn(sampleGDS)

    pedFile <- data.frame(famId=paste0("F", seq_len(length(listSample))),
                          id = sampleId[listS],
                          fa=rep("0",length(listSample)),
                          mo=rep("0",length(listSample)),
                          sex=sampleANNO$sex[listS],
                          pheno=rep(0,length(listSample)),
                          stringsAsFactors = FALSE)

    write.table(pedFile, pedOUT,
                quote=FALSE, sep="\t",
                row.names = FALSE,
                col.names = FALSE)

}



#' @title create a file tped file for plink from the gds file
#'
#' @description TODO
#'
#' @param gds a \code{gds} object.
#'
#' @param listSamples  a \code{array} with the sample to keep
#'
#' @param listSNP  a \code{array} with the snp.id to keep
#'
#' @param pedOUT TODO a PATH and file name to the output file
#'
#' @return TODO a \code{vector} of \code{numeric}
#'
#' @examples
#'
#' # TODO
#'
#' @author Pascal Belleau, Astrid Desch&ecirc;nes and Alex Krasnitz
#' @importFrom gdsfmt index.gdsn read.gdsn
#' @keywords internal

gds2tped <- function(gds, listSample, listSNP, pedOUT){

    sampleGDS <- index.gdsn(gds, "sample.id")
    sampleId <-read.gdsn(sampleGDS)
    listS <- which(sampleId %in% listSample)

    snpGDS <- index.gdsn(gds, "snp.id")
    snpId <- read.gdsn(snpGDS)
    listKeep <- which(snpId %in% listSNP)
    snpId <- snpId[listKeep]

    snpGDS <- index.gdsn(gds, "snp.chromosome")
    snpChr <- read.gdsn(snpGDS)
    snpChr <- snpChr[listKeep]

    snpGDS <- index.gdsn(gds, "snp.position")
    snpPos <- read.gdsn(snpGDS)
    snpPos <- snpPos[listKeep]

    tped <- list()
    tped[[1]] <- snpChr
    tped[[2]] <- snpId
    tped[[3]] <- rep(0,length(snpId))
    tped[[4]] <- snpPos
    k<-4
    geno.var <- index.gdsn(gds, "genotype")
    for(i in listS){
        k <- k + 1

        tmp <- read.gdsn(geno.var, start=c(1, i), count=c(-1,1))[listKeep]

        # 0 1 0 1 0 1
        tped[[k]] <- (tmp == 2) + 1
        k <- k + 1
        tped[[k]] <- (tmp > 0) + 1

    }

    #tped <- do.call(cbind, tped)

    write.table(tped, pedOUT,
                quote=FALSE, sep="\t",
                row.names = FALSE,
                col.names = FALSE)

}


#' @title Function just wrap snpgdsIBDKING
#'
#' @description TODO
#'
#' @param gds a \code{gds} object.
#'
#' @param sampleId  a \code{array} with the sample to keep
#' if NULL all
#'
#' @param snp.id  a \code{array} with the snp.id to keep
#' if NULL all
#'
#' @param maf  a \code{numeric} mininum allelic frequency keep.
#'
#' @return TODO ibd.robust
#'
#' @examples
#'
#' # TODO
#'
#' @author Pascal Belleau, Astrid Desch&ecirc;nes and Alex Krasnitz
#'
#' @importFrom SNPRelate snpgdsIBDKING
#'
#' @keywords internal

runIBDKING <- function(gds,
                       sampleId = NULL,
                       snp.id = NULL,
                       maf=0.05){

    ibd.robust <- snpgdsIBDKING(gds,
                                 sample.id=sampleId,
                                 snp.id=snp.id,
                                 maf=maf,
                                 type="KING-robust")
    return(ibd.robust)

}


#' @title TODO just a wrapper of snpgdsLDpruning
#'
#' @description TODO
#'
#' @param gds an object of class \code{gds} opened
#'
#' @param method the parameter method in SNPRelate::snpgdsLDpruning
#'
#' @param listSamples A \code{vector} of \code{string} corresponding to the sample.ids
#' use in LDpruning
#'
#' @param listKeep the list of snp.id keep
#'
#' @param slide.max.bp.v
#'
#' @param ld.threshold.v
#'
#' @param np
#'
#' @param verbose.v
#'
#' @return TODO a \code{vector} of \code{numeric}
#'
#' @examples
#'
#' # TODO
#'
#' @author Pascal Belleau, Astrid Desch&ecirc;nes and Alex Krasnitz
#'
#' @importFrom SNPRelate snpgdsOpen snpgdsLDpruning
#' @importFrom gdsfmt closefn.gds
#'
#' @keywords internal

runLDPruning <- function(gds,
                         method="corr",
                         listSamples=NULL,
                         listKeep=NULL,
                         slide.max.bp.v = 5e5,
                         ld.threshold.v=sqrt(0.1),
                         np = 1,
                         verbose.v=FALSE){

    # validate the para
    # showfile.gds(closeall=FALSE, verbose=TRUE)



    snpset <- snpgdsLDpruning(gds, method="corr",
                              sample.id = listSamples,
                              snp.id = listKeep,
                              slide.max.bp = slide.max.bp.v,
                              ld.threshold = ld.threshold.v,
                              num.thread=np,
                              verbose = verbose.v)
    # closefn.gds(gds)
    return(snpset)
}


#' @title fill the pruned.study in the gds file
#'
#' @description TODO
#'
#' @param gds an object of class \code{gds} opened
#'
#' @param PATHPRUNED TODO
#'
#' @param listSamples A \code{vector} of \code{string} corresponding to the sample.ids
#'
#' @param prefFile \code{string} with the prefix of the pruned file
#'
#' @return NULL
#'
#' @examples
#'
#' # TODO
#'
#' @author Pascal Belleau, Astrid Desch&ecirc;nes and Alex Krasnitz
#' @importFrom gdsfmt add.gdsn write.gdsn
#' @keywords internal


addGDSStudyPruning <- function(gds, PATHPRUNED,
                               listSamples, prefFile){

    # The list of the pruned SNP
    listPruning <- dir(PATHPRUNED, pattern = ".+.rds")

    # remove the .Obj.rds files if they are there
    listPruning <- listPruning[grep("\\.Obj\\.rds$", listPruning, perl = TRUE, invert = TRUE)]

    # remove prefFIle and .rds from the fle name
    listSampleNames <- gsub(paste0("^", prefFile), "", gsub(".rds$", "", listPruning))

    # Get the snp.id
    snp.id <- read.gdsn(index.gdsn(gds, "snp.id"))


    # Loop on the samples
    for(i in seq_len(length(listSamples))){

        pos <- which(listSampleNames == listSamples[i])
        print(paste0(listSamples[i], " ", Sys.time()))
        if( length(pos) != 1){
            stop(paste0("Missing samples ", listSamples[i]))
        }
        pruned <- readRDS(file.path(PATHPRUNED, listPruning[pos]))

        # list snp.id keep after pruning
        g <- pruned %in% snp.id
        if(i == 1){

            var.Pruned <- add.gdsn(gds, "pruned.study",
                                g,
                                valdim=c( length(snp.id), 1), storage="sp.int8")


        } else{
            append.gdsn(var.Pruned,g)
        }

        print(paste0(listSamples[i], " ", i, " ", Sys.time()))
    }
}