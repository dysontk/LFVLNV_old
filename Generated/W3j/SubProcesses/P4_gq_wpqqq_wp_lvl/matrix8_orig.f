      SUBROUTINE SMATRIX8(P,ANS)
C     
C     Generated by MadGraph5_aMC@NLO v. 3.5.3, 2023-12-23
C     By the MadGraph5_aMC@NLO Development Team
C     Visit launchpad.net/madgraph5 and amcatnlo.web.cern.ch
C     
C     MadGraph5_aMC@NLO for Madevent Version
C     
C     Returns amplitude squared -- no average over initial
C      state/symmetry factor
C     and helicities
C     for the point in phase space P(0:3,NEXTERNAL)
C     
C     Process: g d~ > w+ u u~ u~ WEIGHTED<=5 @4
C     *   Decay: w+ > e+ ve WEIGHTED<=2
C     Process: g s~ > w+ c c~ c~ WEIGHTED<=5 @4
C     *   Decay: w+ > e+ ve WEIGHTED<=2
C     
      USE DISCRETESAMPLER
      IMPLICIT NONE
C     
C     CONSTANTS
C     
      INCLUDE 'genps.inc'
      INCLUDE 'maxconfigs.inc'
      INCLUDE 'nexternal.inc'
      INCLUDE 'maxamps.inc'
      INTEGER                 NCOMB
      PARAMETER (             NCOMB=128)
      INTEGER    NGRAPHS
      PARAMETER (NGRAPHS=24)
      INTEGER    NDIAGS
      PARAMETER (NDIAGS=24)
      INTEGER    THEL
      PARAMETER (THEL=2*NCOMB)
C     
C     ARGUMENTS 
C     
      REAL*8 P(0:3,NEXTERNAL),ANS
C     
C     global (due to reading writting) 
C     
      LOGICAL GOODHEL(NCOMB,2)
      INTEGER NTRY(2)
      COMMON/BLOCK_GOODHEL/NTRY,GOODHEL

C     
C     LOCAL VARIABLES 
C     
      INTEGER CONFSUB(MAXSPROC,LMAXCONFIGS)
      INCLUDE 'config_subproc_map.inc'
      INTEGER NHEL(NEXTERNAL,NCOMB)
      INTEGER ISHEL(2)
      REAL*8 T,MATRIX8
      REAL*8 R,SUMHEL,TS(NCOMB)
      INTEGER I,IDEN
      INTEGER JC(NEXTERNAL),II
      REAL*8 HWGT, XTOT, XTRY, XREJ, XR, YFRAC(0:NCOMB)
      INTEGER NGOOD(2), IGOOD(NCOMB,2)
      INTEGER JHEL(2), J, JJ
      INTEGER THIS_NTRY(2)
      SAVE THIS_NTRY
      INTEGER NB_FAIL
      SAVE NB_FAIL
      DATA THIS_NTRY /0,0/
      DATA NB_FAIL /0/
      DOUBLE PRECISION GET_CHANNEL_CUT
      EXTERNAL GET_CHANNEL_CUT

C     
C     This is just to temporarily store the reference grid for
C      helicity of the DiscreteSampler so as to obtain its number of
C      entries with ref_helicity_grid%n_tot_entries
      TYPE(SAMPLEDDIMENSION) REF_HELICITY_GRID
C     
C     GLOBAL VARIABLES
C     
      LOGICAL INIT_MODE
      COMMON /TO_DETERMINE_ZERO_HEL/INIT_MODE
      DOUBLE PRECISION AMP2(MAXAMPS), JAMP2(0:MAXFLOW)
      COMMON/TO_AMPS/  AMP2,       JAMP2

      CHARACTER*101         HEL_BUFF
      COMMON/TO_HELICITY/  HEL_BUFF

      INTEGER NB_SPIN_STATE_IN(2)
      COMMON /NB_HEL_STATE/ NB_SPIN_STATE_IN

      INTEGER IMIRROR,IPROC
      COMMON/TO_MIRROR/ IMIRROR,IPROC

      DOUBLE PRECISION TMIN_FOR_CHANNEL
      INTEGER SDE_STRAT  ! 1 means standard single diagram enhancement strategy,
C     2 means approximation by the	denominator of the propagator
      COMMON/TO_CHANNEL_STRAT/TMIN_FOR_CHANNEL,	SDE_STRAT

      REAL*8 POL(2)
      COMMON/TO_POLARIZATION/ POL

      DOUBLE PRECISION SMALL_WIDTH_TREATMENT
      COMMON/NARROW_WIDTH/SMALL_WIDTH_TREATMENT

      INTEGER          ISUM_HEL
      LOGICAL                    MULTI_CHANNEL
      COMMON/TO_MATRIX/ISUM_HEL, MULTI_CHANNEL
      INTEGER MAPCONFIG(0:LMAXCONFIGS), ICONFIG
      COMMON/TO_MCONFIGS/MAPCONFIG, ICONFIG
      INTEGER SUBDIAG(MAXSPROC),IB(2)
      COMMON/TO_SUB_DIAG/SUBDIAG,IB
      DATA XTRY, XREJ /0,0/
      DATA NGOOD /0,0/
      DATA ISHEL/0,0/
      SAVE YFRAC, IGOOD, JHEL
      DATA (NHEL(I,   1),I=1,7) /-1,-1, 1,-1,-1, 1, 1/
      DATA (NHEL(I,   2),I=1,7) /-1,-1, 1,-1,-1, 1,-1/
      DATA (NHEL(I,   3),I=1,7) /-1,-1, 1,-1,-1,-1, 1/
      DATA (NHEL(I,   4),I=1,7) /-1,-1, 1,-1,-1,-1,-1/
      DATA (NHEL(I,   5),I=1,7) /-1,-1, 1,-1, 1, 1, 1/
      DATA (NHEL(I,   6),I=1,7) /-1,-1, 1,-1, 1, 1,-1/
      DATA (NHEL(I,   7),I=1,7) /-1,-1, 1,-1, 1,-1, 1/
      DATA (NHEL(I,   8),I=1,7) /-1,-1, 1,-1, 1,-1,-1/
      DATA (NHEL(I,   9),I=1,7) /-1,-1, 1, 1,-1, 1, 1/
      DATA (NHEL(I,  10),I=1,7) /-1,-1, 1, 1,-1, 1,-1/
      DATA (NHEL(I,  11),I=1,7) /-1,-1, 1, 1,-1,-1, 1/
      DATA (NHEL(I,  12),I=1,7) /-1,-1, 1, 1,-1,-1,-1/
      DATA (NHEL(I,  13),I=1,7) /-1,-1, 1, 1, 1, 1, 1/
      DATA (NHEL(I,  14),I=1,7) /-1,-1, 1, 1, 1, 1,-1/
      DATA (NHEL(I,  15),I=1,7) /-1,-1, 1, 1, 1,-1, 1/
      DATA (NHEL(I,  16),I=1,7) /-1,-1, 1, 1, 1,-1,-1/
      DATA (NHEL(I,  17),I=1,7) /-1,-1,-1,-1,-1, 1, 1/
      DATA (NHEL(I,  18),I=1,7) /-1,-1,-1,-1,-1, 1,-1/
      DATA (NHEL(I,  19),I=1,7) /-1,-1,-1,-1,-1,-1, 1/
      DATA (NHEL(I,  20),I=1,7) /-1,-1,-1,-1,-1,-1,-1/
      DATA (NHEL(I,  21),I=1,7) /-1,-1,-1,-1, 1, 1, 1/
      DATA (NHEL(I,  22),I=1,7) /-1,-1,-1,-1, 1, 1,-1/
      DATA (NHEL(I,  23),I=1,7) /-1,-1,-1,-1, 1,-1, 1/
      DATA (NHEL(I,  24),I=1,7) /-1,-1,-1,-1, 1,-1,-1/
      DATA (NHEL(I,  25),I=1,7) /-1,-1,-1, 1,-1, 1, 1/
      DATA (NHEL(I,  26),I=1,7) /-1,-1,-1, 1,-1, 1,-1/
      DATA (NHEL(I,  27),I=1,7) /-1,-1,-1, 1,-1,-1, 1/
      DATA (NHEL(I,  28),I=1,7) /-1,-1,-1, 1,-1,-1,-1/
      DATA (NHEL(I,  29),I=1,7) /-1,-1,-1, 1, 1, 1, 1/
      DATA (NHEL(I,  30),I=1,7) /-1,-1,-1, 1, 1, 1,-1/
      DATA (NHEL(I,  31),I=1,7) /-1,-1,-1, 1, 1,-1, 1/
      DATA (NHEL(I,  32),I=1,7) /-1,-1,-1, 1, 1,-1,-1/
      DATA (NHEL(I,  33),I=1,7) /-1, 1, 1,-1,-1, 1, 1/
      DATA (NHEL(I,  34),I=1,7) /-1, 1, 1,-1,-1, 1,-1/
      DATA (NHEL(I,  35),I=1,7) /-1, 1, 1,-1,-1,-1, 1/
      DATA (NHEL(I,  36),I=1,7) /-1, 1, 1,-1,-1,-1,-1/
      DATA (NHEL(I,  37),I=1,7) /-1, 1, 1,-1, 1, 1, 1/
      DATA (NHEL(I,  38),I=1,7) /-1, 1, 1,-1, 1, 1,-1/
      DATA (NHEL(I,  39),I=1,7) /-1, 1, 1,-1, 1,-1, 1/
      DATA (NHEL(I,  40),I=1,7) /-1, 1, 1,-1, 1,-1,-1/
      DATA (NHEL(I,  41),I=1,7) /-1, 1, 1, 1,-1, 1, 1/
      DATA (NHEL(I,  42),I=1,7) /-1, 1, 1, 1,-1, 1,-1/
      DATA (NHEL(I,  43),I=1,7) /-1, 1, 1, 1,-1,-1, 1/
      DATA (NHEL(I,  44),I=1,7) /-1, 1, 1, 1,-1,-1,-1/
      DATA (NHEL(I,  45),I=1,7) /-1, 1, 1, 1, 1, 1, 1/
      DATA (NHEL(I,  46),I=1,7) /-1, 1, 1, 1, 1, 1,-1/
      DATA (NHEL(I,  47),I=1,7) /-1, 1, 1, 1, 1,-1, 1/
      DATA (NHEL(I,  48),I=1,7) /-1, 1, 1, 1, 1,-1,-1/
      DATA (NHEL(I,  49),I=1,7) /-1, 1,-1,-1,-1, 1, 1/
      DATA (NHEL(I,  50),I=1,7) /-1, 1,-1,-1,-1, 1,-1/
      DATA (NHEL(I,  51),I=1,7) /-1, 1,-1,-1,-1,-1, 1/
      DATA (NHEL(I,  52),I=1,7) /-1, 1,-1,-1,-1,-1,-1/
      DATA (NHEL(I,  53),I=1,7) /-1, 1,-1,-1, 1, 1, 1/
      DATA (NHEL(I,  54),I=1,7) /-1, 1,-1,-1, 1, 1,-1/
      DATA (NHEL(I,  55),I=1,7) /-1, 1,-1,-1, 1,-1, 1/
      DATA (NHEL(I,  56),I=1,7) /-1, 1,-1,-1, 1,-1,-1/
      DATA (NHEL(I,  57),I=1,7) /-1, 1,-1, 1,-1, 1, 1/
      DATA (NHEL(I,  58),I=1,7) /-1, 1,-1, 1,-1, 1,-1/
      DATA (NHEL(I,  59),I=1,7) /-1, 1,-1, 1,-1,-1, 1/
      DATA (NHEL(I,  60),I=1,7) /-1, 1,-1, 1,-1,-1,-1/
      DATA (NHEL(I,  61),I=1,7) /-1, 1,-1, 1, 1, 1, 1/
      DATA (NHEL(I,  62),I=1,7) /-1, 1,-1, 1, 1, 1,-1/
      DATA (NHEL(I,  63),I=1,7) /-1, 1,-1, 1, 1,-1, 1/
      DATA (NHEL(I,  64),I=1,7) /-1, 1,-1, 1, 1,-1,-1/
      DATA (NHEL(I,  65),I=1,7) / 1,-1, 1,-1,-1, 1, 1/
      DATA (NHEL(I,  66),I=1,7) / 1,-1, 1,-1,-1, 1,-1/
      DATA (NHEL(I,  67),I=1,7) / 1,-1, 1,-1,-1,-1, 1/
      DATA (NHEL(I,  68),I=1,7) / 1,-1, 1,-1,-1,-1,-1/
      DATA (NHEL(I,  69),I=1,7) / 1,-1, 1,-1, 1, 1, 1/
      DATA (NHEL(I,  70),I=1,7) / 1,-1, 1,-1, 1, 1,-1/
      DATA (NHEL(I,  71),I=1,7) / 1,-1, 1,-1, 1,-1, 1/
      DATA (NHEL(I,  72),I=1,7) / 1,-1, 1,-1, 1,-1,-1/
      DATA (NHEL(I,  73),I=1,7) / 1,-1, 1, 1,-1, 1, 1/
      DATA (NHEL(I,  74),I=1,7) / 1,-1, 1, 1,-1, 1,-1/
      DATA (NHEL(I,  75),I=1,7) / 1,-1, 1, 1,-1,-1, 1/
      DATA (NHEL(I,  76),I=1,7) / 1,-1, 1, 1,-1,-1,-1/
      DATA (NHEL(I,  77),I=1,7) / 1,-1, 1, 1, 1, 1, 1/
      DATA (NHEL(I,  78),I=1,7) / 1,-1, 1, 1, 1, 1,-1/
      DATA (NHEL(I,  79),I=1,7) / 1,-1, 1, 1, 1,-1, 1/
      DATA (NHEL(I,  80),I=1,7) / 1,-1, 1, 1, 1,-1,-1/
      DATA (NHEL(I,  81),I=1,7) / 1,-1,-1,-1,-1, 1, 1/
      DATA (NHEL(I,  82),I=1,7) / 1,-1,-1,-1,-1, 1,-1/
      DATA (NHEL(I,  83),I=1,7) / 1,-1,-1,-1,-1,-1, 1/
      DATA (NHEL(I,  84),I=1,7) / 1,-1,-1,-1,-1,-1,-1/
      DATA (NHEL(I,  85),I=1,7) / 1,-1,-1,-1, 1, 1, 1/
      DATA (NHEL(I,  86),I=1,7) / 1,-1,-1,-1, 1, 1,-1/
      DATA (NHEL(I,  87),I=1,7) / 1,-1,-1,-1, 1,-1, 1/
      DATA (NHEL(I,  88),I=1,7) / 1,-1,-1,-1, 1,-1,-1/
      DATA (NHEL(I,  89),I=1,7) / 1,-1,-1, 1,-1, 1, 1/
      DATA (NHEL(I,  90),I=1,7) / 1,-1,-1, 1,-1, 1,-1/
      DATA (NHEL(I,  91),I=1,7) / 1,-1,-1, 1,-1,-1, 1/
      DATA (NHEL(I,  92),I=1,7) / 1,-1,-1, 1,-1,-1,-1/
      DATA (NHEL(I,  93),I=1,7) / 1,-1,-1, 1, 1, 1, 1/
      DATA (NHEL(I,  94),I=1,7) / 1,-1,-1, 1, 1, 1,-1/
      DATA (NHEL(I,  95),I=1,7) / 1,-1,-1, 1, 1,-1, 1/
      DATA (NHEL(I,  96),I=1,7) / 1,-1,-1, 1, 1,-1,-1/
      DATA (NHEL(I,  97),I=1,7) / 1, 1, 1,-1,-1, 1, 1/
      DATA (NHEL(I,  98),I=1,7) / 1, 1, 1,-1,-1, 1,-1/
      DATA (NHEL(I,  99),I=1,7) / 1, 1, 1,-1,-1,-1, 1/
      DATA (NHEL(I, 100),I=1,7) / 1, 1, 1,-1,-1,-1,-1/
      DATA (NHEL(I, 101),I=1,7) / 1, 1, 1,-1, 1, 1, 1/
      DATA (NHEL(I, 102),I=1,7) / 1, 1, 1,-1, 1, 1,-1/
      DATA (NHEL(I, 103),I=1,7) / 1, 1, 1,-1, 1,-1, 1/
      DATA (NHEL(I, 104),I=1,7) / 1, 1, 1,-1, 1,-1,-1/
      DATA (NHEL(I, 105),I=1,7) / 1, 1, 1, 1,-1, 1, 1/
      DATA (NHEL(I, 106),I=1,7) / 1, 1, 1, 1,-1, 1,-1/
      DATA (NHEL(I, 107),I=1,7) / 1, 1, 1, 1,-1,-1, 1/
      DATA (NHEL(I, 108),I=1,7) / 1, 1, 1, 1,-1,-1,-1/
      DATA (NHEL(I, 109),I=1,7) / 1, 1, 1, 1, 1, 1, 1/
      DATA (NHEL(I, 110),I=1,7) / 1, 1, 1, 1, 1, 1,-1/
      DATA (NHEL(I, 111),I=1,7) / 1, 1, 1, 1, 1,-1, 1/
      DATA (NHEL(I, 112),I=1,7) / 1, 1, 1, 1, 1,-1,-1/
      DATA (NHEL(I, 113),I=1,7) / 1, 1,-1,-1,-1, 1, 1/
      DATA (NHEL(I, 114),I=1,7) / 1, 1,-1,-1,-1, 1,-1/
      DATA (NHEL(I, 115),I=1,7) / 1, 1,-1,-1,-1,-1, 1/
      DATA (NHEL(I, 116),I=1,7) / 1, 1,-1,-1,-1,-1,-1/
      DATA (NHEL(I, 117),I=1,7) / 1, 1,-1,-1, 1, 1, 1/
      DATA (NHEL(I, 118),I=1,7) / 1, 1,-1,-1, 1, 1,-1/
      DATA (NHEL(I, 119),I=1,7) / 1, 1,-1,-1, 1,-1, 1/
      DATA (NHEL(I, 120),I=1,7) / 1, 1,-1,-1, 1,-1,-1/
      DATA (NHEL(I, 121),I=1,7) / 1, 1,-1, 1,-1, 1, 1/
      DATA (NHEL(I, 122),I=1,7) / 1, 1,-1, 1,-1, 1,-1/
      DATA (NHEL(I, 123),I=1,7) / 1, 1,-1, 1,-1,-1, 1/
      DATA (NHEL(I, 124),I=1,7) / 1, 1,-1, 1,-1,-1,-1/
      DATA (NHEL(I, 125),I=1,7) / 1, 1,-1, 1, 1, 1, 1/
      DATA (NHEL(I, 126),I=1,7) / 1, 1,-1, 1, 1, 1,-1/
      DATA (NHEL(I, 127),I=1,7) / 1, 1,-1, 1, 1,-1, 1/
      DATA (NHEL(I, 128),I=1,7) / 1, 1,-1, 1, 1,-1,-1/
      DATA IDEN/192/

C     To be able to control when the matrix<i> subroutine can add
C      entries to the grid for the MC over helicity configuration
      LOGICAL ALLOW_HELICITY_GRID_ENTRIES
      COMMON/TO_ALLOW_HELICITY_GRID_ENTRIES/ALLOW_HELICITY_GRID_ENTRIES

C     ----------
C     BEGIN CODE
C     ----------

      NTRY(IMIRROR)=NTRY(IMIRROR)+1
      THIS_NTRY(IMIRROR) = THIS_NTRY(IMIRROR)+1
      DO I=1,NEXTERNAL
        JC(I) = +1
      ENDDO

      IF (MULTI_CHANNEL) THEN
        DO I=1,NDIAGS
          AMP2(I)=0D0
        ENDDO
        JAMP2(0)=4
        DO I=1,INT(JAMP2(0))
          JAMP2(I)=0D0
        ENDDO
      ENDIF
      ANS = 0D0
      WRITE(HEL_BUFF,'(20I5)') (0,I=1,NEXTERNAL)
      DO I=1,NCOMB
        TS(I)=0D0
      ENDDO

        !   If the helicity grid status is 0, this means that it is not yet initialized.
        !   If HEL_PICKED==-1, this means that calls to other matrix<i> where in initialization mode as well for the helicity.
      IF ((ISHEL(IMIRROR).EQ.0.AND.ISUM_HEL.EQ.0)
     $ .OR.(DS_GET_DIM_STATUS('Helicity').EQ.0).OR.(HEL_PICKED.EQ.-1))
     $  THEN
        DO I=1,NCOMB
          IF (GOODHEL(I,IMIRROR) .OR. NTRY(IMIRROR)
     $     .LE.MAXTRIES.OR.(ISUM_HEL.NE.0).OR.THIS_NTRY(IMIRROR).LE.10)
     $      THEN
            T=MATRIX8(P ,NHEL(1,I),JC(1),I)

            IF (ISUM_HEL.NE.0.AND.DS_GET_DIM_STATUS('Helicity')
     $       .EQ.0.AND.ALLOW_HELICITY_GRID_ENTRIES) THEN
              CALL DS_ADD_ENTRY('Helicity',I,T)
            ENDIF
            ANS=ANS+DABS(T)
            TS(I)=T
          ENDIF
        ENDDO
        IF(NTRY(IMIRROR).EQ.(MAXTRIES+1)) THEN
          CALL RESET_CUMULATIVE_VARIABLE()  ! avoid biais of the initialization
        ENDIF
        IF (ISUM_HEL.NE.0) THEN
            !         We set HEL_PICKED to -1 here so that later on, the call to DS_add_point in dsample.f does not add anything to the grid since it was already done here.
          HEL_PICKED = -1
            !         For safety, hardset the helicity sampling jacobian to 0.0d0 to make sure it is not .
          HEL_JACOBIAN   = 1.0D0
            !         We don't want to re-update the helicity grid if it was already updated by another matrix<i>, so we make sure that the reference grid is empty.
          REF_HELICITY_GRID = DS_GET_DIMENSION(REF_GRID,'Helicity')
          IF((DS_GET_DIM_STATUS('Helicity').EQ.1)
     $     .AND.(REF_HELICITY_GRID%N_TOT_ENTRIES.EQ.0)) THEN
              !           If we finished the initialization we can update the grid so as to start sampling over it.
              !           However the grid will now be filled by dsample with different kind of weights (including pdf, flux, etc...) so by setting the grid_mode of the reference grid to 'initialization' we make sure it will be overwritten (as opposed to 'combined') by the running grid at the next update.
            CALL DS_UPDATE_GRID('Helicity')
            CALL DS_SET_GRID_MODE('Helicity','init')
          ENDIF
        ELSE
          JHEL(IMIRROR) = 1
          IF(NTRY(IMIRROR).LE.MAXTRIES.OR.THIS_NTRY(IMIRROR).LE.10)THEN
            DO I=1,NCOMB
              IF(INIT_MODE) THEN
                IF (DABS(TS(I)).GT.ANS*LIMHEL/NCOMB) THEN
                  PRINT *, 'Matrix Element/Good Helicity: 8 ', I,
     $              'IMIRROR', IMIRROR
                ENDIF
              ELSE IF (.NOT.GOODHEL(I,IMIRROR) .AND. (DABS(TS(I))
     $         .GT.ANS*LIMHEL/NCOMB)) THEN
                GOODHEL(I,IMIRROR)=.TRUE.
                NGOOD(IMIRROR) = NGOOD(IMIRROR) +1
                IGOOD(NGOOD(IMIRROR),IMIRROR) = I
                PRINT *,'Added good helicity ',I,TS(I)*NCOMB/ANS,' in'
     $           //' event ',NTRY(IMIRROR), 'local:',THIS_NTRY(IMIRROR)
              ENDIF
            ENDDO
          ENDIF
          IF(NTRY(IMIRROR).EQ.MAXTRIES)THEN
            ISHEL(IMIRROR)=MIN(ISUM_HEL,NGOOD(IMIRROR))
          ENDIF
        ENDIF
      ELSE IF (.NOT.INIT_MODE) THEN  ! random helicity 
C       The helicity configuration was chosen already by genps and put
C        in a common block defined in genps.inc.
        I = HEL_PICKED

        T=MATRIX8(P ,NHEL(1,I),JC(1),I)


C       Always one helicity at a time
        ANS = T
C       Include the Jacobian from helicity sampling
        ANS = ANS * HEL_JACOBIAN

        WRITE(HEL_BUFF,'(20i5)')(NHEL(II,I),II=1,NEXTERNAL)
      ELSE
        ANS = 1D0
        RETURN
      ENDIF
      IF (ANS.NE.0D0.AND.(ISUM_HEL .NE. 1.OR.HEL_PICKED.EQ.-1)) THEN
        CALL RANMAR(R)
        SUMHEL=0D0
        DO I=1,NCOMB
          SUMHEL=SUMHEL+DABS(TS(I))/ANS
          IF(R.LT.SUMHEL)THEN
            WRITE(HEL_BUFF,'(20i5)')(NHEL(II,I),II=1,NEXTERNAL)
C           Set right sign for ANS, based on sign of chosen helicity
            ANS=DSIGN(ANS,TS(I))
            GOTO 10
          ENDIF
        ENDDO
 10     CONTINUE
      ENDIF
      IF (MULTI_CHANNEL) THEN
        XTOT=0D0
        DO I=1,LMAXCONFIGS
          J = CONFSUB(8, I)
          IF (J.NE.0) THEN
            IF(SDE_STRAT.EQ.1) THEN
              AMP2(J) = AMP2(J) * GET_CHANNEL_CUT(P, I)
              XTOT=XTOT+AMP2(J)
            ELSE
              AMP2(J) = GET_CHANNEL_CUT(P, I)
              XTOT=XTOT+AMP2(J)
            ENDIF
          ENDIF
        ENDDO
        IF (XTOT.NE.0D0) THEN
          ANS=ANS*AMP2(SUBDIAG(8))/XTOT
        ELSE IF(ANS.NE.0D0) THEN
          IF(NB_FAIL.GE.10)THEN
            WRITE(*,*) 'Problem in the multi-channeling. All amp2 are'
     $       //' zero but not the total matrix-element'

            STOP 1
          ELSE
            NB_FAIL = NB_FAIL +1
          ENDIF
        ENDIF
      ENDIF
      ANS=ANS/DBLE(IDEN)
      END


      REAL*8 FUNCTION MATRIX8(P,NHEL,IC, IHEL)
C     
C     Generated by MadGraph5_aMC@NLO v. 3.5.3, 2023-12-23
C     By the MadGraph5_aMC@NLO Development Team
C     Visit launchpad.net/madgraph5 and amcatnlo.web.cern.ch
C     
C     Returns amplitude squared summed/avg over colors
C     for the point with external lines W(0:6,NEXTERNAL)
C     
C     Process: g d~ > w+ u u~ u~ WEIGHTED<=5 @4
C     *   Decay: w+ > e+ ve WEIGHTED<=2
C     Process: g s~ > w+ c c~ c~ WEIGHTED<=5 @4
C     *   Decay: w+ > e+ ve WEIGHTED<=2
C     
      IMPLICIT NONE
C     
C     CONSTANTS
C     
      INTEGER    NGRAPHS
      PARAMETER (NGRAPHS=24)
      INTEGER                 NCOMB
      PARAMETER (             NCOMB=128)
      INCLUDE 'genps.inc'
      INCLUDE 'nexternal.inc'
      INCLUDE 'maxamps.inc'
      INTEGER    NWAVEFUNCS,     NCOLOR
      PARAMETER (NWAVEFUNCS=13, NCOLOR=4)
      REAL*8     ZERO
      PARAMETER (ZERO=0D0)
      COMPLEX*16 IMAG1
      PARAMETER (IMAG1=(0D0,1D0))
      INTEGER NAMPSO, NSQAMPSO
      PARAMETER (NAMPSO=1, NSQAMPSO=1)
      LOGICAL CHOSEN_SO_CONFIGS(NSQAMPSO)
      DATA CHOSEN_SO_CONFIGS/.TRUE./
      SAVE CHOSEN_SO_CONFIGS
C     
C     ARGUMENTS 
C     
      REAL*8 P(0:3,NEXTERNAL)
      INTEGER NHEL(NEXTERNAL), IC(NEXTERNAL)
      INTEGER IHEL
C     
C     LOCAL VARIABLES 
C     
      INTEGER I,J,M,N
      COMPLEX*16 ZTEMP, TMP_JAMP(14)
      REAL*8 CF(NCOLOR,NCOLOR)
      COMPLEX*16 AMP(NGRAPHS), JAMP(NCOLOR,NAMPSO)
      COMPLEX*16 W(6,NWAVEFUNCS)
C     Needed for v4 models
      COMPLEX*16 DUM0,DUM1
      DATA DUM0, DUM1/(0D0, 0D0), (1D0, 0D0)/

      DOUBLE PRECISION FK_MDL_WW
      DOUBLE PRECISION FK_ZERO
      SAVE FK_MDL_WW
      SAVE FK_ZERO

      LOGICAL FIRST
      DATA FIRST /.TRUE./
      SAVE FIRST
C     
C     FUNCTION
C     
      INTEGER SQSOINDEX8
C     
C     GLOBAL VARIABLES
C     
      DOUBLE PRECISION AMP2(MAXAMPS), JAMP2(0:MAXFLOW)
      COMMON/TO_AMPS/  AMP2,       JAMP2
      INCLUDE 'coupl.inc'

      DOUBLE PRECISION SMALL_WIDTH_TREATMENT
      COMMON/NARROW_WIDTH/SMALL_WIDTH_TREATMENT

      LOGICAL INIT_MODE
      COMMON/TO_DETERMINE_ZERO_HEL/INIT_MODE

      LOGICAL ZEROAMP_8(NCOMB,NGRAPHS)
      COMMON/TO_ZEROAMP_8/ZEROAMP_8

      DOUBLE PRECISION TMIN_FOR_CHANNEL
      INTEGER SDE_STRAT  ! 1 means standard single diagram enhancement strategy,
C     2 means approximation by the	denominator of the propagator
      COMMON/TO_CHANNEL_STRAT/TMIN_FOR_CHANNEL,	SDE_STRAT

C     
C     COLOR DATA
C     
      DATA (CF(I,  1),I=  1,  4) /1.200000000000000D+01
     $ ,4.000000000000000D+00,4.000000000000000D+00,0.000000000000000D
     $ +00/
C     1 T(1,2,6) T(5,7)
      DATA (CF(I,  2),I=  1,  4) /4.000000000000000D+00
     $ ,1.200000000000000D+01,0.000000000000000D+00,4.000000000000000D
     $ +00/
C     1 T(1,2,7) T(5,6)
      DATA (CF(I,  3),I=  1,  4) /4.000000000000000D+00
     $ ,0.000000000000000D+00,1.200000000000000D+01,4.000000000000000D
     $ +00/
C     1 T(1,5,6) T(2,7)
      DATA (CF(I,  4),I=  1,  4) /0.000000000000000D+00
     $ ,4.000000000000000D+00,4.000000000000000D+00,1.200000000000000D
     $ +01/
C     1 T(1,5,7) T(2,6)
C     ----------
C     BEGIN CODE
C     ----------
      IF (FIRST) THEN
        FIRST=.FALSE.
        IF(ZERO.NE.0D0) FK_ZERO = SIGN(MAX(ABS(ZERO), ABS(ZERO
     $   *SMALL_WIDTH_TREATMENT)), ZERO)
        IF(MDL_WW.NE.0D0) FK_MDL_WW = SIGN(MAX(ABS(MDL_WW), ABS(MDL_MW
     $   *SMALL_WIDTH_TREATMENT)), MDL_WW)

        IF(INIT_MODE) THEN
          ZEROAMP_8(:,:) = .TRUE.
        ENDIF
      ENDIF


      CALL VXXXXX(P(0,1),ZERO,NHEL(1),-1*IC(1),W(1,1))
      CALL OXXXXX(P(0,2),ZERO,NHEL(2),-1*IC(2),W(1,2))
      CALL IXXXXX(P(0,3),ZERO,NHEL(3),-1*IC(3),W(1,3))
      CALL OXXXXX(P(0,4),ZERO,NHEL(4),+1*IC(4),W(1,4))
      CALL FFV2_3(W(1,3),W(1,4),GC_100,MDL_MW, FK_MDL_WW,W(1,5))
      CALL OXXXXX(P(0,5),ZERO,NHEL(5),+1*IC(5),W(1,4))
      CALL IXXXXX(P(0,6),ZERO,NHEL(6),-1*IC(6),W(1,3))
      CALL IXXXXX(P(0,7),ZERO,NHEL(7),-1*IC(7),W(1,6))
      CALL FFV1_2(W(1,3),W(1,1),GC_11,ZERO, FK_ZERO,W(1,7))
      CALL FFV2_1(W(1,2),W(1,5),GC_100,ZERO, FK_ZERO,W(1,8))
      CALL FFV1P0_3(W(1,7),W(1,4),GC_11,ZERO, FK_ZERO,W(1,9))
C     Amplitude(s) for diagram number 1
      CALL FFV1_0(W(1,6),W(1,8),W(1,9),GC_11,AMP(1))
      CALL FFV1P0_3(W(1,6),W(1,4),GC_11,ZERO, FK_ZERO,W(1,10))
C     Amplitude(s) for diagram number 2
      CALL FFV1_0(W(1,7),W(1,8),W(1,10),GC_11,AMP(2))
      CALL FFV2_2(W(1,6),W(1,5),GC_100,ZERO, FK_ZERO,W(1,11))
C     Amplitude(s) for diagram number 3
      CALL FFV1_0(W(1,11),W(1,2),W(1,9),GC_11,AMP(3))
      CALL FFV2_2(W(1,7),W(1,5),GC_100,ZERO, FK_ZERO,W(1,9))
C     Amplitude(s) for diagram number 4
      CALL FFV1_0(W(1,9),W(1,2),W(1,10),GC_11,AMP(4))
      CALL FFV1_1(W(1,4),W(1,1),GC_11,ZERO, FK_ZERO,W(1,9))
      CALL FFV2_2(W(1,3),W(1,5),GC_100,ZERO, FK_ZERO,W(1,7))
      CALL FFV1P0_3(W(1,6),W(1,9),GC_11,ZERO, FK_ZERO,W(1,12))
C     Amplitude(s) for diagram number 5
      CALL FFV1_0(W(1,7),W(1,2),W(1,12),GC_11,AMP(5))
      CALL FFV1P0_3(W(1,3),W(1,9),GC_11,ZERO, FK_ZERO,W(1,13))
C     Amplitude(s) for diagram number 6
      CALL FFV1_0(W(1,6),W(1,8),W(1,13),GC_11,AMP(6))
C     Amplitude(s) for diagram number 7
      CALL FFV1_0(W(1,3),W(1,8),W(1,12),GC_11,AMP(7))
C     Amplitude(s) for diagram number 8
      CALL FFV1_0(W(1,11),W(1,2),W(1,13),GC_11,AMP(8))
      CALL FFV1_1(W(1,2),W(1,1),GC_11,ZERO, FK_ZERO,W(1,13))
C     Amplitude(s) for diagram number 9
      CALL FFV1_0(W(1,7),W(1,13),W(1,10),GC_11,AMP(9))
      CALL FFV1P0_3(W(1,3),W(1,4),GC_11,ZERO, FK_ZERO,W(1,12))
      CALL FFV2_1(W(1,13),W(1,5),GC_100,ZERO, FK_ZERO,W(1,9))
C     Amplitude(s) for diagram number 10
      CALL FFV1_0(W(1,6),W(1,9),W(1,12),GC_11,AMP(10))
C     Amplitude(s) for diagram number 11
      CALL FFV1_0(W(1,11),W(1,13),W(1,12),GC_11,AMP(11))
C     Amplitude(s) for diagram number 12
      CALL FFV1_0(W(1,3),W(1,9),W(1,10),GC_11,AMP(12))
      CALL FFV1_2(W(1,6),W(1,1),GC_11,ZERO, FK_ZERO,W(1,9))
      CALL FFV1P0_3(W(1,9),W(1,4),GC_11,ZERO, FK_ZERO,W(1,13))
C     Amplitude(s) for diagram number 13
      CALL FFV1_0(W(1,7),W(1,2),W(1,13),GC_11,AMP(13))
      CALL FFV2_2(W(1,9),W(1,5),GC_100,ZERO, FK_ZERO,W(1,4))
C     Amplitude(s) for diagram number 14
      CALL FFV1_0(W(1,4),W(1,2),W(1,12),GC_11,AMP(14))
C     Amplitude(s) for diagram number 15
      CALL FFV1_0(W(1,9),W(1,8),W(1,12),GC_11,AMP(15))
C     Amplitude(s) for diagram number 16
      CALL FFV1_0(W(1,3),W(1,8),W(1,13),GC_11,AMP(16))
      CALL FFV1_2(W(1,7),W(1,1),GC_11,ZERO, FK_ZERO,W(1,13))
C     Amplitude(s) for diagram number 17
      CALL FFV1_0(W(1,13),W(1,2),W(1,10),GC_11,AMP(17))
      CALL VVV1P0_1(W(1,1),W(1,10),GC_10,ZERO, FK_ZERO,W(1,13))
C     Amplitude(s) for diagram number 18
      CALL FFV1_0(W(1,7),W(1,2),W(1,13),GC_11,AMP(18))
      CALL VVV1P0_1(W(1,1),W(1,12),GC_10,ZERO, FK_ZERO,W(1,7))
C     Amplitude(s) for diagram number 19
      CALL FFV1_0(W(1,6),W(1,8),W(1,7),GC_11,AMP(19))
      CALL FFV1_1(W(1,8),W(1,1),GC_11,ZERO, FK_ZERO,W(1,9))
C     Amplitude(s) for diagram number 20
      CALL FFV1_0(W(1,6),W(1,9),W(1,12),GC_11,AMP(20))
C     Amplitude(s) for diagram number 21
      CALL FFV1_0(W(1,11),W(1,2),W(1,7),GC_11,AMP(21))
      CALL FFV1_2(W(1,11),W(1,1),GC_11,ZERO, FK_ZERO,W(1,7))
C     Amplitude(s) for diagram number 22
      CALL FFV1_0(W(1,7),W(1,2),W(1,12),GC_11,AMP(22))
C     Amplitude(s) for diagram number 23
      CALL FFV1_0(W(1,3),W(1,9),W(1,10),GC_11,AMP(23))
C     Amplitude(s) for diagram number 24
      CALL FFV1_0(W(1,3),W(1,8),W(1,13),GC_11,AMP(24))

      JAMP(:,:) = (0D0,0D0)
C     JAMPs contributing to orders ALL_ORDERS=1
      TMP_JAMP(10) = AMP(19) +  AMP(21)  ! used 2 times
      TMP_JAMP(9) = AMP(14) +  AMP(15)  ! used 2 times
      TMP_JAMP(8) = AMP(13) +  AMP(16)  ! used 2 times
      TMP_JAMP(7) = AMP(6) +  AMP(8)  ! used 2 times
      TMP_JAMP(6) = AMP(5) +  AMP(7)  ! used 2 times
      TMP_JAMP(5) = AMP(18) +  AMP(24)  ! used 2 times
      TMP_JAMP(4) = AMP(2) +  AMP(4)  ! used 2 times
      TMP_JAMP(3) = AMP(1) +  AMP(3)  ! used 2 times
      TMP_JAMP(2) = AMP(10) +  AMP(11)  ! used 2 times
      TMP_JAMP(1) = AMP(9) +  AMP(12)  ! used 2 times
      TMP_JAMP(14) = TMP_JAMP(9) +  AMP(22)  ! used 2 times
      TMP_JAMP(13) = TMP_JAMP(4) +  AMP(17)  ! used 2 times
      TMP_JAMP(12) = TMP_JAMP(2) +  AMP(20)  ! used 2 times
      TMP_JAMP(11) = TMP_JAMP(1) +  AMP(23)  ! used 2 times
      JAMP(1,1) = (5.000000000000000D-01)*TMP_JAMP(3)
     $ +((0.000000000000000D+00,-5.000000000000000D-01))*TMP_JAMP(10)
     $ +(1.666666666666667D-01)*TMP_JAMP(11)+(5.000000000000000D-01)
     $ *TMP_JAMP(12)+(1.666666666666667D-01)*TMP_JAMP(13)
      JAMP(2,1) = ((0.000000000000000D+00,5.000000000000000D-01))
     $ *TMP_JAMP(5)+(-5.000000000000000D-01)*TMP_JAMP(8)+(
     $ -5.000000000000000D-01)*TMP_JAMP(11)+(-1.666666666666667D-01)
     $ *TMP_JAMP(12)+(-1.666666666666667D-01)*TMP_JAMP(14)
      JAMP(3,1) = (-1.666666666666667D-01)*TMP_JAMP(3)
     $ +((0.000000000000000D+00,-5.000000000000000D-01))*TMP_JAMP(5)+(
     $ -5.000000000000000D-01)*TMP_JAMP(6)+(-1.666666666666667D-01)
     $ *TMP_JAMP(7)+(-5.000000000000000D-01)*TMP_JAMP(13)
      JAMP(4,1) = (1.666666666666667D-01)*TMP_JAMP(6)
     $ +(5.000000000000000D-01)*TMP_JAMP(7)+(1.666666666666667D-01)
     $ *TMP_JAMP(8)+((0.000000000000000D+00,5.000000000000000D-01))
     $ *TMP_JAMP(10)+(5.000000000000000D-01)*TMP_JAMP(14)

      IF(INIT_MODE)THEN
        DO I=1, NGRAPHS
          IF (AMP(I).NE.0) THEN
            ZEROAMP_8(IHEL,I) = .FALSE.
          ENDIF
        ENDDO
      ENDIF

      MATRIX8 = 0.D0
      DO M = 1, NAMPSO
        DO I = 1, NCOLOR
          ZTEMP = (0.D0,0.D0)
          DO J = 1, NCOLOR
            ZTEMP = ZTEMP + CF(J,I)*JAMP(J,M)
          ENDDO
          DO N = 1, NAMPSO

            MATRIX8 = MATRIX8 + ZTEMP*DCONJG(JAMP(I,N))

          ENDDO
        ENDDO
      ENDDO

      IF(SDE_STRAT.EQ.1)THEN
        AMP2(9)=AMP2(9)+AMP(9)*DCONJG(AMP(9))
        AMP2(12)=AMP2(12)+AMP(12)*DCONJG(AMP(12))
        AMP2(7)=AMP2(7)+AMP(7)*DCONJG(AMP(7))
        AMP2(5)=AMP2(5)+AMP(5)*DCONJG(AMP(5))
        AMP2(2)=AMP2(2)+AMP(2)*DCONJG(AMP(2))
        AMP2(4)=AMP2(4)+AMP(4)*DCONJG(AMP(4))
        AMP2(16)=AMP2(16)+AMP(16)*DCONJG(AMP(16))
        AMP2(13)=AMP2(13)+AMP(13)*DCONJG(AMP(13))
        AMP2(23)=AMP2(23)+AMP(23)*DCONJG(AMP(23))
        AMP2(24)=AMP2(24)+AMP(24)*DCONJG(AMP(24))
        AMP2(17)=AMP2(17)+AMP(17)*DCONJG(AMP(17))
        AMP2(18)=AMP2(18)+AMP(18)*DCONJG(AMP(18))
        AMP2(1)=AMP2(1)+AMP(1)*DCONJG(AMP(1))
        AMP2(3)=AMP2(3)+AMP(3)*DCONJG(AMP(3))
        AMP2(6)=AMP2(6)+AMP(6)*DCONJG(AMP(6))
        AMP2(8)=AMP2(8)+AMP(8)*DCONJG(AMP(8))
        AMP2(10)=AMP2(10)+AMP(10)*DCONJG(AMP(10))
        AMP2(11)=AMP2(11)+AMP(11)*DCONJG(AMP(11))
        AMP2(14)=AMP2(14)+AMP(14)*DCONJG(AMP(14))
        AMP2(15)=AMP2(15)+AMP(15)*DCONJG(AMP(15))
        AMP2(19)=AMP2(19)+AMP(19)*DCONJG(AMP(19))
        AMP2(20)=AMP2(20)+AMP(20)*DCONJG(AMP(20))
        AMP2(21)=AMP2(21)+AMP(21)*DCONJG(AMP(21))
        AMP2(22)=AMP2(22)+AMP(22)*DCONJG(AMP(22))
      ENDIF

      DO I = 1, NCOLOR
        DO M = 1, NAMPSO
          DO N = 1, NAMPSO

            JAMP2(I)=JAMP2(I)+DABS(DBLE(JAMP(I,M)*DCONJG(JAMP(I,N))))

          ENDDO
        ENDDO
      ENDDO

      END

      SUBROUTINE PRINT_ZERO_AMP_8()

      IMPLICIT NONE
      INTEGER    NGRAPHS
      PARAMETER (NGRAPHS=24)

      INTEGER    NCOMB
      PARAMETER (NCOMB=128)

      LOGICAL ZEROAMP_8(NCOMB, NGRAPHS)
      COMMON/TO_ZEROAMP_8/ZEROAMP_8

      INTEGER I,J
      LOGICAL ALL_FALSE

      DO I=1, NGRAPHS
        ALL_FALSE = .TRUE.
        DO J=1,NCOMB
          IF (.NOT.ZEROAMP_8(J, I)) THEN
            ALL_FALSE = .FALSE.
            EXIT
          ENDIF
        ENDDO
        IF (ALL_FALSE) THEN
          WRITE(*,*) 'Amplitude/ZEROAMP:', 8, I
        ELSE
          DO J=1,NCOMB
            IF (ZEROAMP_8(J, I)) THEN
              WRITE(*,*) 'HEL/ZEROAMP:', 8, J  , I
            ENDIF
          ENDDO
        ENDIF
      ENDDO

      RETURN
      END
C     Set of functions to handle the array indices of the split orders


      INTEGER FUNCTION SQSOINDEX8(ORDERINDEXA, ORDERINDEXB)
C     
C     This functions plays the role of the interference matrix. It can
C      be hardcoded or 
C     made more elegant using hashtables if its execution speed ever
C      becomes a relevant
C     factor. From two split order indices, it return the
C      corresponding index in the squared 
C     order canonical ordering.
C     
C     CONSTANTS
C     

      INTEGER    NSO, NSQUAREDSO, NAMPSO
      PARAMETER (NSO=1, NSQUAREDSO=1, NAMPSO=1)
C     
C     ARGUMENTS
C     
      INTEGER ORDERINDEXA, ORDERINDEXB
C     
C     LOCAL VARIABLES
C     
      INTEGER I, SQORDERS(NSO)
      INTEGER AMPSPLITORDERS(NAMPSO,NSO)
      DATA (AMPSPLITORDERS(  1,I),I=  1,  1) /    1/
      COMMON/AMPSPLITORDERS8/AMPSPLITORDERS
C     
C     FUNCTION
C     
      INTEGER SOINDEX_FOR_SQUARED_ORDERS8
C     
C     BEGIN CODE
C     
      DO I=1,NSO
        SQORDERS(I)=AMPSPLITORDERS(ORDERINDEXA,I)
     $   +AMPSPLITORDERS(ORDERINDEXB,I)
      ENDDO
      SQSOINDEX8=SOINDEX_FOR_SQUARED_ORDERS8(SQORDERS)
      END

      INTEGER FUNCTION SOINDEX_FOR_SQUARED_ORDERS8(ORDERS)
C     
C     This functions returns the integer index identifying the squared
C      split orders list passed in argument which corresponds to the
C      values of the following list of couplings (and in this order).
C     []
C     
C     CONSTANTS
C     
      INTEGER    NSO, NSQSO, NAMPSO
      PARAMETER (NSO=1, NSQSO=1, NAMPSO=1)
C     
C     ARGUMENTS
C     
      INTEGER ORDERS(NSO)
C     
C     LOCAL VARIABLES
C     
      INTEGER I,J
      INTEGER SQSPLITORDERS(NSQSO,NSO)
      DATA (SQSPLITORDERS(  1,I),I=  1,  1) /    2/
      COMMON/SQPLITORDERS8/SQPLITORDERS
C     
C     BEGIN CODE
C     
      DO I=1,NSQSO
        DO J=1,NSO
          IF (ORDERS(J).NE.SQSPLITORDERS(I,J)) GOTO 1009
        ENDDO
        SOINDEX_FOR_SQUARED_ORDERS8 = I
        RETURN
 1009   CONTINUE
      ENDDO

      WRITE(*,*) 'ERROR:: Stopping in function'
      WRITE(*,*) 'SOINDEX_FOR_SQUARED_ORDERS8'
      WRITE(*,*) 'Could not find squared orders ',(ORDERS(I),I=1,NSO)
      STOP

      END

      SUBROUTINE GET_NSQSO_BORN8(NSQSO)
C     
C     Simple subroutine returning the number of squared split order
C     contributions returned when calling smatrix_split_orders 
C     

      INTEGER    NSQUAREDSO
      PARAMETER  (NSQUAREDSO=1)

      INTEGER NSQSO

      NSQSO=NSQUAREDSO

      END

C     This is the inverse subroutine of SOINDEX_FOR_SQUARED_ORDERS.
C      Not directly useful, but provided nonetheless.
      SUBROUTINE GET_SQUARED_ORDERS_FOR_SOINDEX8(SOINDEX,ORDERS)
C     
C     This functions returns the orders identified by the squared
C      split order index in argument. Order values correspond to
C      following list of couplings (and in this order):
C     []
C     
C     CONSTANTS
C     
      INTEGER    NSO, NSQSO
      PARAMETER (NSO=1, NSQSO=1)
C     
C     ARGUMENTS
C     
      INTEGER SOINDEX, ORDERS(NSO)
C     
C     LOCAL VARIABLES
C     
      INTEGER I
      INTEGER SQPLITORDERS(NSQSO,NSO)
      COMMON/SQPLITORDERS8/SQPLITORDERS
C     
C     BEGIN CODE
C     
      IF (SOINDEX.GT.0.AND.SOINDEX.LE.NSQSO) THEN
        DO I=1,NSO
          ORDERS(I) =  SQPLITORDERS(SOINDEX,I)
        ENDDO
        RETURN
      ENDIF

      WRITE(*,*) 'ERROR:: Stopping function'
     $ //' GET_SQUARED_ORDERS_FOR_SOINDEX8'
      WRITE(*,*) 'Could not find squared orders index ',SOINDEX
      STOP

      END SUBROUTINE

C     This is the inverse subroutine of getting amplitude SO orders.
C      Not directly useful, but provided nonetheless.
      SUBROUTINE GET_ORDERS_FOR_AMPSOINDEX8(SOINDEX,ORDERS)
C     
C     This functions returns the orders identified by the split order
C      index in argument. Order values correspond to following list of
C      couplings (and in this order):
C     []
C     
C     CONSTANTS
C     
      INTEGER    NSO, NAMPSO
      PARAMETER (NSO=1, NAMPSO=1)
C     
C     ARGUMENTS
C     
      INTEGER SOINDEX, ORDERS(NSO)
C     
C     LOCAL VARIABLES
C     
      INTEGER I
      INTEGER AMPSPLITORDERS(NAMPSO,NSO)
      COMMON/AMPSPLITORDERS8/AMPSPLITORDERS
C     
C     BEGIN CODE
C     
      IF (SOINDEX.GT.0.AND.SOINDEX.LE.NAMPSO) THEN
        DO I=1,NSO
          ORDERS(I) =  AMPSPLITORDERS(SOINDEX,I)
        ENDDO
        RETURN
      ENDIF

      WRITE(*,*) 'ERROR:: Stopping function GET_ORDERS_FOR_AMPSOINDEX8'
      WRITE(*,*) 'Could not find amplitude split orders index ',SOINDEX
      STOP

      END SUBROUTINE

C     This function is not directly useful, but included for
C      completeness
      INTEGER FUNCTION SOINDEX_FOR_AMPORDERS8(ORDERS)
C     
C     This functions returns the integer index identifying the
C      amplitude split orders passed in argument which correspond to
C      the values of the following list of couplings (and in this
C      order):
C     []
C     
C     CONSTANTS
C     
      INTEGER    NSO, NAMPSO
      PARAMETER (NSO=1, NAMPSO=1)
C     
C     ARGUMENTS
C     
      INTEGER ORDERS(NSO)
C     
C     LOCAL VARIABLES
C     
      INTEGER I,J
      INTEGER AMPSPLITORDERS(NAMPSO,NSO)
      COMMON/AMPSPLITORDERS8/AMPSPLITORDERS
C     
C     BEGIN CODE
C     
      DO I=1,NAMPSO
        DO J=1,NSO
          IF (ORDERS(J).NE.AMPSPLITORDERS(I,J)) GOTO 1009
        ENDDO
        SOINDEX_FOR_AMPORDERS8 = I
        RETURN
 1009   CONTINUE
      ENDDO

      WRITE(*,*) 'ERROR:: Stopping function SOINDEX_FOR_AMPORDERS8'
      WRITE(*,*) 'Could not find squared orders ',(ORDERS(I),I=1,NSO)
      STOP

      END

