      SUBROUTINE EPRINT
C
C  THIS SUBROUTINE PRINTS THE LAST ERROR MESSAGE, IF ANY.
C
C/6S
C     INTEGER MESSG(1)
C/7S
      CHARACTER*1 MESSG(1)
C/
C
      CALL E9RINT(MESSG,1,1,.FALSE.)
      RETURN
C
      END
