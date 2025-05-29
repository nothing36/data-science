set -e  # exit on failure

# show output only if --verbose
VERBOSE=0
if [[ "$1" == "--verbose" ]]; then
  VERBOSE=1
fi

log() {
  if [[ $VERBOSE -eq 1 ]]; then
    echo "$@"
  fi
}

run() {
  if [[ $VERBOSE -eq 1 ]]; then
    "$@"
  else
    "$@" &> /dev/null
  fi
}

trap 'echo "❌ Setup failed at line $LINENO. Use --verbose for detailed logs." >&2' ERR

echo "📦 Creating virtual environment..."
run python3 -m venv .venv

echo "🔁 Activating virtual environment..."
source .venv/bin/activate

echo "⬆️ Upgrading pip..."
run pip install --upgrade pip

echo "🔥 Installing PyTorch with CUDA 12.6..."
run pip install torch torchvision torchaudio

if [[ -f requirements.txt ]]; then
  echo "📄 Installing additional project dependencies from requirements.txt..."
  run pip install -r requirements.txt
else
  echo "⚠️ No requirements.txt found. Skipping extra installs."
fi

echo "🧪 Verifying PyTorch + GPU:"
python -c "import torch; print('- PyTorch:', torch.__version__); print('- CUDA available:', torch.cuda.is_available())"

echo "✅ Setup completed successfully. Removing script..."
rm -- "$0"