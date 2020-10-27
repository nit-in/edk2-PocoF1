#!/bin/bash
set -e

EXTRACTED_DIR="./workspace/xbl_extract/fv_extracted"
DEST_DIR="./PocoF1Pkg/Binary"

cleanup() {
	rm -rf ./workspace/xbl_extract
}

extract_xbl() {
	mkdir -p ./workspace/xbl_extract
	cp ./xbl.elf ./workspace/xbl_extract/xbl.elf
	cd ./workspace/xbl_extract

	uefi-firmware-parser -b -e xbl.elf
	7z x "$(find -name section0.guid)"
	uefi-firmware-parser -e -b --verbose -o ./fv_extracted section0

	cd ../../
}

extract_dxe_without_depex() {
	[ -d "$DEST_DIR/$2" ] || mkdir -p "$DEST_DIR/$2"
	cp "$EXTRACTED_DIR/volume-8/file-$1/section0.pe" "$DEST_DIR/$2/$2.efi"
}

extract_dxe_with_depex() {
	[ -d "$DEST_DIR/$2" ] || mkdir -p "$DEST_DIR/$2"
	cp "$EXTRACTED_DIR/volume-8/file-$1/section0.dxe.depex" "$DEST_DIR/$2/$2.depex"
	cp "$EXTRACTED_DIR/volume-8/file-$1/section1.pe" "$DEST_DIR/$2/$2.efi"
}

copy_binary_files() {
	extract_dxe_with_depex "90a49afd-422f-08ae-9611-e788d3804845" "EnvDxe"
	extract_dxe_without_depex "5e0eae60-eaed-4d75-b8bf-edbbaabc3f09" "SecurityDxe"
	extract_dxe_without_depex "c2f9a4f5-f7b4-43e7-ba99-5ea804cc103a" "ASN1X509Dxe"
	extract_dxe_without_depex "32c71e68-83a8-46ed-aed1-094e71b12057" "SecRSADxe"
	extract_dxe_with_depex "f541d663-4a48-40aa-aabf-ff158ccae34c" "SmemDxe"
	extract_dxe_with_depex "8e9bd160-b184-11df-94e2-0800200c9a66" "DALSys"
	extract_dxe_with_depex "af9763a2-033b-4109-8e17-56a98d380c92" "HWIODxeDriver"
	extract_dxe_with_depex "10e193df-9966-44e7-b17c-59dd831e20fc" "ChipInfo"
	extract_dxe_with_depex "b105211b-bbbd-4add-a3b0-d1cf4a52154c" "PlatformInfoDxeDriver"
	extract_dxe_with_depex "7942a7eb-b7d5-4e2e-b908-831e4de55b58" "GlinkDxe"
	extract_dxe_with_depex "e43128a8-8692-42b6-8afa-676158578d18" "ULogDxe"
	extract_dxe_with_depex "cb29f4d1-7f37-4692-a416-93e82e219711" "NpaDxe"
	extract_dxe_with_depex "4db5dea6-5302-4d1a-8a82-677a683b0d29" "ClockDxe"
	extract_dxe_with_depex "f10f76db-42c1-533f-34a8-69be24653110" "SdccDxe"
	extract_dxe_with_depex "0d35cd8e-97ea-4f9a-96af-0f0d89f76567" "UFSDxe"
	extract_dxe_with_depex "b003d837-44cc-b38b-7811-deb5ebbd74d8" "QdssDxe"
	extract_dxe_with_depex "02b01ad5-7e59-43e8-a6d8-238180613a5a" "EmuVariableRuntimeDxe"
	extract_dxe_with_depex "8681cc5a-0df6-441e-b4b8-e915c538f067" "DALTLMM"
	extract_dxe_with_depex "04de8591-d2b3-4077-bbbe-b12070094eb6" "I2C"
	extract_dxe_with_depex "2a7b4bef-80cd-49e1-b473-374ba4d673fc" "SPMI"
	extract_dxe_with_depex "7a32bd23-f735-4f57-aa1a-447d2fe3be0d" "SPI"
	extract_dxe_with_depex "5776232e-082d-4b75-9a0e-fe1d13f7a5d9" "PmicDxe"
	extract_dxe_with_depex "5a5cb8ca-9382-4e0c-b383-77fb517cd9eb" "AdcDxe"
	extract_dxe_with_depex "4bce7f36-428e-4393-99e3-7e0844404dba" "QcomChargerDxeLA"
	extract_dxe_with_depex "5bd181db-0487-4f1a-ae73-820e165611b3" "ButtonsDxe"
	extract_dxe_without_depex "3adf8dda-1850-44c5-8c63-bb991849bc6f" "HashDxe"
	extract_dxe_without_depex "b0d3689e-11f8-43c6-8ece-023a29cec35b" "RngDxe"
}

patch_binary_files() {
	bspatch "$DEST_DIR/ClockDxe/ClockDxe.efi" "$DEST_DIR/ClockDxe/ClockDxe.patched.efi" "$DEST_DIR/ClockDxe/ClockDxe.diff"
	rm "$DEST_DIR/ClockDxe/ClockDxe.efi"
	mv "$DEST_DIR/ClockDxe/ClockDxe.patched.efi" "$DEST_DIR/ClockDxe/ClockDxe.efi"
}

cleanup
extract_xbl
copy_binary_files
patch_binary_files
