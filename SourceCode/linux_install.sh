#!/bin/bash

# Color settings
YES='\033[0;32m'
NO='\033[0;31m'
INFO='\033[0;34m'
NC='\033[0m' # No Color

# --- Variables ---
SOURCE_PY_FILE="./source/linux/shortlink.py" # Linux-specific source file
DEST_DIR="/opt/shortlink-cli"
DEST_PY_FILE="$DEST_DIR/shortlink.py"
TOOL_NAME="shortlink"
DEST_WRAPPER="/usr/local/bin/$TOOL_NAME" # Wrapper'ın kurulacağı yer
# -----------------

# -----------------------------------------------------------
# 1 & 2. Dependency Check and Install (Python/Pip/Requests - Kısaltıldı)
# -----------------------------------------------------------
# (Bu kısım, Python ve Requests kurulumunu yapar, önceki versiyonlarla aynıdır.)
# ...

# -----------------------------------------------------------
# 3. Installing Application Files (Dosyaları Kopyalama)
# -----------------------------------------------------------
echo -e "${INFO}### 3. Installing Application Files...${NC}"

if [ ! -f "$SOURCE_PY_FILE" ]; then
    echo -e "${NO}ERROR: Source file '$SOURCE_PY_FILE' not found! Make sure to run the script from the root directory.${NC}"
    exit 1
fi

# 1. Python dosyasını özel dizine kopyala
sudo mkdir -p "$DEST_DIR"
sudo cp "$SOURCE_PY_FILE" "$DEST_PY_FILE"
sudo chmod +x "$DEST_PY_FILE" # Çalıştırma izni ver
echo -e "${YES}Application core file installed to: $DEST_PY_FILE${NC}"

# 2. Wrapper (Sarmalayıcı) script'i /usr/local/bin/ içine yaz
echo -e "${INFO}### 4. Creating PATH Wrapper...${NC}"

WRAPPER_CONTENT=$(cat <<EOF
#!/bin/bash
# shortlink wrapper script (installed to PATH)

# Execute the main Python file, passing all arguments to it
python3 $DEST_PY_FILE "\$@"
EOF
)

# Wrapper dosyasını oluştur ve içeriğini yaz
echo "$WRAPPER_CONTENT" | sudo tee "$DEST_WRAPPER" > /dev/null
sudo chmod +x "$DEST_WRAPPER"

echo -e "${YES}Wrapper script created at: $DEST_WRAPPER${NC}"
echo -e "${YES}The '$TOOL_NAME' command is now globally available!${NC}"


echo -e "\n${YES}******************************************************${NC}"
echo -e "${YES}Installation SUCCESSFUL! Your command is ready.${NC}"
echo -e "${YES}Usage: $TOOL_NAME https://your-url.com${NC}"
echo -e "${YES}******************************************************${NC}"